
output "F5_PRIVATE_EXTERNAL_IP" {
  value = module.f5.f5_external_ip
}

output "F5_PRIVATE_INTERNAL_IP" {
  value = module.f5.f5_internal_ip
}

output "F5_PRIVATE_MGMT_IP" {
  value = module.f5.f5_management_ip
}

output "F5_FLOATNG_MGMT_IP" {
  value = module.f5.f5_management_floating_ip
}

output "F5_INSTANCE_STATUS" {
  value = module.f5.resource_status
}

output "SNAT_NEXT_HOP_ADDRESS" {
  value = module.f5.snat_next_hop_address
}

output "VIRTUAL_SERVER_NEXT_HOP_ADDRESS" {
  value = module.f5.virtual_service_next_hop_address
}

output "DEFAULT_GATEWAY" {
  value = module.f5.default_gateway
}

output "F5_INSTANCE_NAME" {
  value = module.f5.resource_name
}

# Note: assumes that the external nic is the second non-primary network interface on the instance
output "_COMMAND_FLOATING_IP_MOVE" {
  value = "ibmcloud is floating-ip-update <floating_ip_id> --nic-id ${data.ibm_is_instance.f5_instance.network_interfaces[1].id}"
}

