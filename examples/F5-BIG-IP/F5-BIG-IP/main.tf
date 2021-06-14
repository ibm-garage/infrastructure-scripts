provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../infrastructure/terraform.tfstate"
  }
}

module "f5" {
  source = "github.com/f5devcentral/ibmcloud_schematics_bigip_multinic_public_images"
  
  TF_VERSION       = "0.14"
  region           = var.region
  resource_group   = var.resource_group_name
  instance_name    = "${var.basename}-f5"
  hostname         = "${var.basename}-f5"
  instance_profile = "cx2-4x8"
  ssh_key_name     = var.ssh_key_name

  tmos_admin_password          = var.f5_admin_password
  bigip_management_floating_ip = true

  management_subnet_id = data.terraform_remote_state.infra.outputs.f5_mgmt_subnet_id
  internal_subnet_id   = data.terraform_remote_state.infra.outputs.f5_internal_subnet_id
  external_subnet_id   = data.terraform_remote_state.infra.outputs.f5_external_subnet_id

  license_type         = "byol"
  byol_license_basekey = var.f5_license

}

data "ibm_is_instance" "f5_instance" {
  depends_on = [
    module.f5
  ]
  name        = module.f5.resource_name
}
