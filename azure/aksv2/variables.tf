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

variable "aks_name" {
  description = "The AKS service name"
}

variable "owner_group" {
  description = "The security group owner name"
}

variable "tag" {
  description = "The AKS tag"
  default = ""
}

variable "k8s_version" {
  description = "The Kubernetes version"
  default = "1.21.9"
}
