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

# tmos_image_name - The name of VPC image to use for the F5 BIG-IP instance
variable "tmos_image_name" {
  type        = string
  default     = "f5-bigip-16-0-1-1-0-0-6-all-1slot-1"
  description = "The image to be used when provisioning the F5 BIG-IP instance"
}

variable "do_declaration_url" {
  type        = string
  default     = ""
  description = "URL to fetch the f5-declarative-onboarding declaration"
}

variable "as3_declaration_url" {
  type        = string
  default     = ""
  description = "URL to fetch the f5-appsvcs-extension declaration"
}

variable "ts_declaration_url" {
  type        = string
  default     = ""
  description = "URL to fetch the f5-telemetry-streaming declaration"
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
