
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  iaas_classic_username = var.iaas_classic_username
  iaas_classic_api_key = var.iaas_classic_api_key
  region           = var.region
}

resource "ibm_compute_ssh_key" "vm_ssh_key" {
    label = "${var.ssh_key.label}"
    notes = "test_ssh_key_notes"
    public_key = "${var.ssh_key.public_key}"
}

resource "ibm_compute_vm_instance" "twc_terraform_sample" {
  hostname                   = "${var.hostname}"
  domain                     = "${var.domain}"
  os_reference_code          = "CENTOS_7_64"
  datacenter                 = "dal13"
  network_speed              = 10
  hourly_billing             = true
  private_network_only       = false
  cores                      = 1
  memory                     = 1024
  disks                      = [25, 10, 20]
  ssh_key_ids                = [ibm_compute_ssh_key.vm_ssh_key.id]
  dedicated_acct_host_only   = true
  local_disk                 = false
}
