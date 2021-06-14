
output "WG_VSI_FLOATING_IP" {
  value = var.provision_wireguard == true ? module.wg_vsi[0].vsi_floating_ip : "Wireguard not provisioned"
}

output "WG_VSI_SUBNET" {
  value = var.provision_wireguard == true ? module.wg_vsi[0].vsi_subnet : "Wireguard not provisioned"
}

output "CLIENT_CONFIGS" {
  value = var.provision_wireguard == true ? module.wg_vsi[0].client_configs : "Wireguard not provisioned"
}

output "f5_mgmt_subnet_id" {
  value = ibm_is_subnet.f5_mgmt_subnet.id
}

output "f5_internal_subnet_id" {
  value = ibm_is_subnet.f5_internal_subnet.id
}

output "f5_external_subnet_id" {
  value = ibm_is_subnet.f5_external_subnet.id
}