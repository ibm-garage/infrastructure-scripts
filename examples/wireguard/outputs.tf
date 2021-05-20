output "WG_VSI_PRIVATE_IP" {
    value = module.wg_vsi.vsi_private_ip
}

output "WG_VSI_FLOATING_IP" {
    value = module.wg_vsi.vsi_floating_ip
}

output "WG_VSI_SUBNET" {
    value = module.wg_vsi.vsi_subnet
}

output "CLIENT_CONFIGS" {
    value = module.wg_vsi.client_configs
}

output "WEB_SERVER_PRIVATE_IP" {
    value = data.ibm_is_instance.webserver_instance.primary_network_interface[0].primary_ipv4_address
}
