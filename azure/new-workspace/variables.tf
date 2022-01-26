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
}
