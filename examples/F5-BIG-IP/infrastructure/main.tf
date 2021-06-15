locals {

}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

data "ibm_is_vpc" "vpc" {
    name = var.vpc_name
}

data "ibm_is_ssh_key" "key" {
    name = var.ssh_key_name
}

# Create three subnets, one for each of the F5 interfaces
resource "ibm_is_subnet" "f5_internal_subnet" {
  name           = "${var.basename}-f5-internal"
  resource_group = data.ibm_resource_group.group.id 
  vpc            = data.ibm_is_vpc.vpc.id
  zone            = var.zone
  
  total_ipv4_address_count = "16"
}

# Create three subnets, one for each of the F5 interfaces
resource "ibm_is_subnet" "f5_external_subnet" {
  name           = "${var.basename}-f5-external"
  resource_group = data.ibm_resource_group.group.id 
  vpc            = data.ibm_is_vpc.vpc.id
  zone            = var.zone
  
  total_ipv4_address_count = "16"
}

# Create three subnets, one for each of the F5 interfaces
resource "ibm_is_subnet" "f5_mgmt_subnet" {
  name           = "${var.basename}-f5-mgmt"
  resource_group = data.ibm_resource_group.group.id 
  vpc            = data.ibm_is_vpc.vpc.id
  zone            = var.zone
  
  total_ipv4_address_count = "16"
}

# Use the Wireguard module to create a server with wireguard running
module "wg_vsi" {
  count  = (var.provision_wireguard == true) ? 1 : 0

  source = "../../../modules/vsi-ubuntu-wireguard"

  region            = var.region
  zone              = var.zone
  resource_group_id = data.ibm_resource_group.group.id
  basename          = var.basename
  ibmcloud_api_key  = var.ibmcloud_api_key
  vpc_id            = data.ibm_is_vpc.vpc.id
  ssh_key_id        = data.ibm_is_ssh_key.key.id
  cidrs             = [ibm_is_subnet.f5_internal_subnet.ipv4_cidr_block,ibm_is_subnet.f5_external_subnet.ipv4_cidr_block,ibm_is_subnet.f5_mgmt_subnet.ipv4_cidr_block]
  wg_cidr           = var.wg_cidr
  wg_clients        = var.wg_clients
  wg_server_config  = var.wg_server_config
}
