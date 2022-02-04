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

variable "resource_group" {
  description = "The Azure Resource Group"
}

variable "owner_sp_name" {
  description = "The security group owner service principal name in the form user@domain"
}

variable "organization_id" {
  description = "The Organization id"
}

variable "workspace_key" {
  description = "The Workspace key"
}

variable "eventhub_namespace_name" {
  description = "The Event Hub namespace name"
  default = ""
}

variable "adx_name" {
  description = "The Azure Data Explorer cluster name"
}

variable "app_platform_name" {
  description = "The Platform App Registration name"
}

variable "app_adt_name" {
  description = "The ADT App Registration name"
}

variable "storage_account_name" {
  description = "The platform storage account name. Must contains a container named terraform"
}

variable "dedicated_eventhub_namespace" {
  type = bool
  description = "Create a dedicated event hub namespace"
  default = true
}

variable "eventhub_namespace_capacity" {
  description = "The event hub namespace capacity in terms of throughput units"
  type = number
  default = 3
}
