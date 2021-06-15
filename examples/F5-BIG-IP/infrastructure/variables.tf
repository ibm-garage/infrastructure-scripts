variable "ibmcloud_api_key" {
	description = "provide your IBM Cloud API Key."
}

variable "region" {
  description = "If a new VPC is needed, this is the region to use."
}

variable "zone" {
  description = "Zone in which to provision the F5."
}

variable "resource_group_name" {
   description = "Name of resource group in which to provision f5 and wireguard"
}

variable "vpc_name" {
  description = "Name of VPC in which to provision F5" 
}

variable "basename" {
  description = "Prefix used to name all resources."
}

variable "ssh_key_name" {
	description = "The name of the ssh key that you will use to access the VSI, it must already be available in the region you are deploying to"
}

variable "provision_wireguard" {
  default     = true
  description = "True if you need a wireguard server to access private ips on like the F5 management console"
}

variable "wg_cidr" {
  type        = string
  default     = "10.0.200.0/24"
  description = "The RFC 4632 CIDR to use for the Wireguard network. This should not conflict with existing subnets."
}

variable "wg_clients" {
  type = list(object({
    publicKey  = string
    privateKey = string
  }))
  default     = []
  description = "Client configuration information for wireguard. At least one public key must be provided."
}

variable "wg_server_config" {
  type = object({
    publicKey  = string
    privateKey = string
  })
  default = null
  description = "Server configuration information for wireguard. The private key must be provided."
}
