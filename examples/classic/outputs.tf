output "id" {
  value = ibm_compute_vm_instance.twc_terraform_sample.id
}
output "domain" {
  value = ibm_compute_vm_instance.twc_terraform_sample.domain
}
output "hostname" {
  value = ibm_compute_vm_instance.twc_terraform_sample.hostname
}

output "public_ip_address" {
  value = ibm_compute_vm_instance.twc_terraform_sample.ipv4_address
}
output "private_ip_address" {
  value = ibm_compute_vm_instance.twc_terraform_sample.ipv4_address_private
}

output "memory" {
  value = ibm_compute_vm_instance.twc_terraform_sample.memory
}
