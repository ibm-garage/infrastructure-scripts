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

variable "f5_admin_password" {
  description = "Admin password for F5 admin console"
  type        = string
  sensitive   = true
}

variable "f5_license" {
  description = "BYOL license for F5"
  type        = string
  sensitive   = true
}
