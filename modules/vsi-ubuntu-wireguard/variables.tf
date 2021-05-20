variable "ibmcloud_api_key" {}

variable "region" {
   description = "Region of the VPC"
}

variable "zone" {
   description = "Zone in which to provision the VSI.  Must be in the same Region as the VPC."
}

variable "resource_group_id" {
   description = "ID of Resource Group in which to provision the VSI."
}

variable "vpc_id" {
   description = "ID of VPC into which to provision the VSI.  A subnet will also be created."
}

variable "basename" {
   default = "wgm"
   type = string
   description = "Prefix used to name all resources."
}

variable "init_timeout" {
   default = "1"
   type = string
   description = "seconds to wait for newly provisioned server to init"
}
variable "cidrs" {
   type = list(string)
   default = []
   description = "Array of cidrs in the VPC that you want to connect to through the vpn.  For example, you can add the subnet ranges for a ROKS or IKS cluster"
}

variable "ssh_key_id" {
   description = "ID of SSH Key already provisioned in the region.  This will be used to access the VSI."
}

variable "wg_cidr" {
   default = "10.0.200.0/24"
   type = string
   description = "The RFC 4632 CIDR to use for the Wireguard network. This should not conflict with existing subnets."
}

variable "wg_clients" {
  type = list(object({
    publicKey = string
    privateKey = string
  }))
  default = []
  description = "List of configuration information for WG clients, at a minimum 'publicKey' fields"
}

variable "wg_server_config" {
  type = object({
    publicKey = string
    privateKey = string
  })
  description = "The server config for wireguard, at minimum need to provide the private key"
}