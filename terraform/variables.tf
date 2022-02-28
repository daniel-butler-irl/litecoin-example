variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API Key with access to manage IAM Roles, Groups, Policies, Service ID (instead of user)"
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Prefix for name of all resource created by this example"
  default     = ""
}

variable "region" {
  type        = string
  description = "Region where resources are created"
  default     = "us-south"
}
