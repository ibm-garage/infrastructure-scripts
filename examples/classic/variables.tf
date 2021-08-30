
// IBM Cloud credentials
variable "ibmcloud_api_key" {
	description = "provide your IBM Cloud API Key."
}
variable "iaas_classic_username" {
	description = "provide your IBM Cloud Classic Infrastructure user name."
}
variable "iaas_classic_api_key" {
	description = "provide your IBM Cloud Classic Infrastructure API Key/"
}

// VSI provisioning parameters
variable "region" {
  description = "Target region of the new VSI."
}
variable "zone" {
  description = "Zone in which to provision the VSI."
}
variable "domain" {
  description = "domain for the new VSI."
}
variable "hostname" {
  description = "hostname for the new VSI."
}
variable "ssh_key" {
  type = object({
    label = string
    public_key = string
  })
  description = "the public key info to ssh to the VSI"
}
