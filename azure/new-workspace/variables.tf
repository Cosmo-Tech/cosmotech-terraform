variable "organization_id" {
  description = "The Organization id"
}

variable "workspace_key" {
  description = "The Workspace key"
}

variable "resource_group" {
  description = "The Azure Resource Group"
}

variable "location" {
  description = "The Azure location"
  default = "West Europe"
}

variable "tenant_id" {
  description = "The Tenant id"
}

variable "owner_sp_name" {
  description = "The security group owner service principal name in the form user@domain"
}
