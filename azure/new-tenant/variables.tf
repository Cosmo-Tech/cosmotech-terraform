variable "location" {
  description = "The Azure location"
  default = "West Europe"
}

variable "tenant_id" {
  description = "The tenant id"
}

variable "subscription_id" {
  description = "The subscription id"
}

variable "client_id" {
  description = "The client id"
}

variable "client_secret" {
  description = "The client secret"
}

variable "resource_group_name" {
  description = "The Azure Resource Group"
}

variable "tenant_name" {
  description = "The new Tenant name"
}

variable "app_platform_name" {
  description = "The Platform App Registration name"
}

variable "app_adt_name" {
  description = "The ADT App Registration name"
}

variable "eventhub_namespace_capacity" {
  description = "The event hub namespace capacity in terms of throughput units"
  type = number
  default = 2
}

variable "aad_groups_and_assignements" {
  description = "Create the Azure Active Directory workspace group and do roles assignements on resources"
  type = bool
  default = true
}

variable "private_endpoint_enabled" {
  type        = bool
  description = "Use private endpoints for services"
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