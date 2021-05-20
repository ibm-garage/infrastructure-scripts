locals {
  ubuntu_image = "ibm-ubuntu-20-04-minimal-amd64-2"
  cloud_init_base = <<EOF
#cloud-config
packages:
  - wireguard
  - wireguard-tools
package_update: true
package_upgrade: true
package_reboot_if_required: true
ssh_pwauth: no
runcmd:
  - passwd -d root
  - sysctl -p /etc/sysctl.d/98-wireguard.conf
  - systemctl enable wg-quick@wg0
  - systemctl restart sshd
power_state:
  mode: reboot
  condition: True
EOF
  server_ip = cidrhost(var.wg_cidr, 1)
  clients = [for c in var.wg_clients : {
    ip = cidrhost(var.wg_cidr, index(var.wg_clients, c) + 2),
    publicKey = c["publicKey"],
    privateKey = lookup(c, "privateKey", "")
  }]
  client_configs = templatefile("${path.module}/wireguard_client.tpl",
                    {
                      floating_ip = ibm_is_floating_ip.vsi_wireguard_floatingip.address,
                      cidrs = var.cidrs,
                      wg_cidr = var.wg_cidr,
                      client_configs = local.clients,
                      server_config = var.wg_server_config
                    })
}

data "template_cloudinit_config" "wg_cloud_config" {
  gzip = false
  base64_encode = false
  part {
    content = local.cloud_init_base
  }

  part {
    content = templatefile("${path.module}/write_wg_config.tpl",
                  {
                    wg_cidr = var.wg_cidr,
                    wg_clients = local.clients,
                    wg_server_ip = local.server_ip,
                    wg_server_privateKey = var.wg_server_config.privateKey
                  })
  }
}

data "ibm_is_image" "ubuntu_image" {
    name = local.ubuntu_image
}

resource "ibm_is_subnet" "subnet_vsi" {
  name            = "${var.basename}-subnet-vsi"
  vpc             = var.vpc_id
  resource_group  = var.resource_group_id
  zone            = var.zone
  total_ipv4_address_count = 32
}

resource "ibm_is_security_group" "vsi_sg" {
    name = "${var.basename}-sg-wireguard"
    vpc = var.vpc_id
    resource_group = var.resource_group_id
}

resource "ibm_is_security_group_rule" "rule-all-outbound" {
    group = ibm_is_security_group.vsi_sg.id
    direction = "outbound"
    remote = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "rule-wireguard-inbound" {
    group = ibm_is_security_group.vsi_sg.id
    direction = "inbound"
    remote = "0.0.0.0/0"
    udp {
        port_min = 65000
        port_max = 65000
    }
}

resource "random_id" "vsi_name_suffix" {
  keepers = {
    # This is the hack pt. 1
    cloud_config_data = data.template_cloudinit_config.wg_cloud_config.rendered
  }

  byte_length = 8
}

resource "ibm_is_instance" "vsi_wireguard" {
  name           = "${var.basename}-wireguard-${random_id.vsi_name_suffix.hex}"
  resource_group = var.resource_group_id
  profile        = "cx2-2x4"
  image          = data.ibm_is_image.ubuntu_image.id
  vpc            = var.vpc_id
  keys           = [var.ssh_key_id]
  zone           = var.zone
  user_data      = random_id.vsi_name_suffix.keepers.cloud_config_data

  primary_network_interface {
    subnet          = ibm_is_subnet.subnet_vsi.id
    security_groups = [ibm_is_security_group.vsi_sg.id]
  }

  # Minimize downtime of the WG link
  lifecycle {
    create_before_destroy = true
  }
}
resource "time_sleep" "vsi_init_wait" {
  create_duration = "${var.init_timeout}s"

  triggers = {
    # This is the hack pt. 2
    target_id = ibm_is_instance.vsi_wireguard.primary_network_interface.0.id
  }
}

resource "ibm_is_floating_ip" "vsi_wireguard_floatingip" {
  name   = "${var.basename}-fip-wireguard"
  target = time_sleep.vsi_init_wait.triggers["target_id"]
  resource_group = var.resource_group_id
}

