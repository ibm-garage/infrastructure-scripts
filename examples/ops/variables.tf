variable "ibmcloud_api_key" {
  type        = string
  sensitive   = true
  description = "IBM Cloud API key to use for creating resources."
}

variable "resource_group" {
  type        = string
  default     = "Default"
  description = "IBMCloud Resource Group"
}

variable "suffix" {
  type        = string
  default     = "dev"
  description = "Suffix to use on resource names"
}

variable "region" {
  type        = string
  default     = "us-south"
  description = "Region in which to create all resources."
}

variable "cluster_instance_id" {
  type        = string
  description = "Cluster ID."
}

variable "namespace_id" {
  type        = string
  default     = "default"
  description = "the namespace in the cluster to hold the logging service credentials to bind to the cluster."
}