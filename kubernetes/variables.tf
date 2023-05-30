variable "tenant_id" {
  type        = string
  description = "The tenant id"
}

variable "subscription_id" {
  type        = string
  description = "The subscription id"
}

variable "client_id" {
  type        = string
  description = "The client id"
}

variable "client_secret" {
  type        = string
  description = "The client secret"
}

variable "location" {
  type    = string
  default = ""
}

variable "namespace" {
  type = string
}

variable "retention_period" {
  type    = string
  default = "720h"
}