variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "disk_size_gb" {
  type = string
  default = "64"
}

variable "disk_sku" {
  type = string
  default = "Premium_LRS"
}

variable "disk_tier" {
  type = string
  default = "P6"
}