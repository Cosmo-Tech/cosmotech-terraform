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

variable "private_endpoint_enabled" {
    type        = bool
    description = "Use private endpoint for the cosmosdb account"
    default     = true
}

variable "private_endpoint_vnet_name" {
    type        = string
    description = "The name of the virtual network for the private endpoints"
    default     = ""
}

variable "private_endpoint_subnet_name" {
    type        = string
    description = "The name of the subnet to create the private endpoint in"
    default     = ""
}