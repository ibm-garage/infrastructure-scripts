provider "ibm" {
  region           = var.region
  ibmcloud_api_key = var.ibmcloud_api_key
  ibmcloud_timeout = 900
}
