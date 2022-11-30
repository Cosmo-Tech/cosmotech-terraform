variable "location" {
  type        = string
  description = "The Azure location"
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "The Azure Resource Group"
}

variable "tenant_name" {
  type        = string
  description = "The new Tenant name"
}

