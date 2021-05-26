locals {
  ubuntu_image = "ibm-ubuntu-20-04-minimal-amd64-2"
  ubuntu_profile = "cx2-2x4"
  user_data = <<EOF
#cloud-config
ssh_pwauth: no
runcmd:
  - passwd -d root
  - sed -i "s/^Include/# Include/g" /etc/ssh/sshd_config
  - systemctl restart sshd
write_files:
  - path: /var/lib/cloud/scripts/per-boot/00-start-server.sh
    permissions: '0755'
    content: |
      #!/bin/bash
      cd /root
      python3 -m http.server 80
  - path: /root/index.html
    content: |
      <html>
        <body><h1>You Did it!</h1></body>
      </html>
EOF
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

resource "ibm_resource_group" "group" {
  name = join("-", [var.basename, "rg"])
}

data "ibm_is_image" "ubuntu_image" {
    name = local.ubuntu_image
}

# Create a VPC
resource "ibm_is_vpc" "vpc" {
  name           = "${var.basename}-vpc"
  resource_group = ibm_resource_group.group.id

  default_security_group_name = "${var.basename}-sg-default"
  default_network_acl_name    = "${var.basename}-acl-default"
  default_routing_table_name  = "${var.basename}-rt-default"
}

# Create a subnet for a VSI that you will connect to over http to the private ip
module "subnet_webserver" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-vpc/modules/subnet"

  name                = "${var.basename}-subnet-webserver"
  resource_group_id   = ibm_resource_group.group.id
  vpc_id              = ibm_is_vpc.vpc.id
  location            = var.zone
  number_of_addresses = 32
}

data "ibm_is_subnet" "subnet" {
  identifier = module.subnet_webserver.subnet_id
}

# Use the Wireguard module to create a server with wireguard running
module "wg_vsi" {
  source = "../../modules/vsi-ubuntu-wireguard"

  region            = var.region
  zone              = var.zone
  resource_group_id = ibm_resource_group.group.id
  basename          = var.basename
  ibmcloud_api_key  = var.ibmcloud_api_key
  vpc_id            = ibm_is_vpc.vpc.id
  ssh_key_id        = var.ssh_key_id
  cidrs             = [data.ibm_is_subnet.subnet.ipv4_cidr_block]
  wg_clients        = var.wg_clients
  wg_server_config  = var.wg_server_config
}

# Create a security group for your VSI that permits inbound http from the security group
# on the wireguard VSI
module "security_group_webserver" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-vpc/modules/security-group"

  create_security_group = true
  name                  = "${var.basename}-sg-webserver"
  resource_group_id     = ibm_resource_group.group.id
  vpc_id                = ibm_is_vpc.vpc.id
  security_group_rules = [
    { name      = "${var.basename}-inbound-wg-http"
      direction = "inbound"
      remote    = module.wg_vsi.security_group_id
      tcp = {
        port_min = 80
        port_max = 80
      },
      ip_version = null
      icmp       = null
      udp        = null
    }
  ]
}

module "vsi_webserver" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-vpc/modules/instance"

  name              = "${var.basename}-vsi-webserver"
  resource_group_id = ibm_resource_group.group.id
  vpc_id            = ibm_is_vpc.vpc.id
  location          = var.zone
  image             = data.ibm_is_image.ubuntu_image.id
  profile           = local.ubuntu_profile
  ssh_keys          = [var.ssh_key_id]
  primary_network_interface = [{
    subnet               = module.subnet_webserver.subnet_id
    interface_name       = "${var.basename}-vsi-webserver-pi"
    primary_ipv4_address = ""
    security_groups      = [module.security_group_webserver.security_group_id[0]]
  }]
  user_data = local.user_data
}

data "ibm_is_instance" "webserver_instance" {
  depends_on = [
    module.vsi_webserver
  ]
  name = "${var.basename}-vsi-webserver"
}
