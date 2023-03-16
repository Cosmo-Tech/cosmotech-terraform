variable "resource_group" {
  type = string
}

variable "cluster_name" {
  type = string
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
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = ""
}

variable "ingress_nginx_version" {
  type    = string
  default = "4.2.1"
}

variable "namespace" {
  type = string
}

variable "monitoring_namespace" {
  type = string
}

variable "loadbalancer_ip" {
  type = string
}

variable "tls_secret_name" {
  type = string
}

variable "api_dns_name" {
  type = string
}

variable "prom_admin_password" {
  type = string
}

variable "cluster_issuer_email" {
  type = string
}

variable "cluster_issuer_name" {
  type = string
}

variable "redis_admin_password" {
  type = string
}

# variable "redis_disk_resource" {
#   type = string
# }

variable "argo_postgresql_password" {
  type = string
}