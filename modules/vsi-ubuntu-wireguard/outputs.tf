output "vsi_id" {
  value = ibm_is_instance.vsi_wireguard.id
}

output "vsi_private_ip" {
  value = ibm_is_instance.vsi_wireguard.primary_network_interface.0.primary_ipv4_address
}

output "vsi_floating_ip" {
  value = ibm_is_floating_ip.vsi_wireguard_floatingip.address
}

output "vsi_subnet" {
  value = ibm_is_subnet.subnet_vsi.ipv4_cidr_block
}

output "client_configs" {
  value = local.client_configs
}

output "security_group_id" {
  value = ibm_is_security_group.vsi_sg.id
}