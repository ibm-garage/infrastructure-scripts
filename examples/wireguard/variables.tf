variable "ibmcloud_api_key" {
	description = "provide your IBM Cloud API Key."
}

variable "region" {
  description = "If a new VPC is needed, this is the region to use.  Ignored, if an existing VPC is specified."
}

variable "zone" {
  description = "Zone in which to provision the VSI.  Must be in the same Region as the VPC."
}

variable "basename" {
  description = "Prefix used to name all resources."
}

variable "ssh_key_id" {
	description = "The id of the ssh key that you will use to access the VSI, it must already be available in the region you are deploying to"
}

variable "wg_cidr" {
  type        = string
  description = "The RFC 4632 CIDR to use for the Wireguard network. This should not conflict with existing subnets."
}

variable "wg_client_configs" {
  type = list(object({
    publicKey  = string
    privateKey = string
  }))
  description = "Client configuration information for wireguard. At least one public key must be provided."
}

variable "wg_server_config" {
  type = object({
    publicKey  = string
    privateKey = string
  })
  description = "Server configuration information for wireguard. The private key must be provided."
}
