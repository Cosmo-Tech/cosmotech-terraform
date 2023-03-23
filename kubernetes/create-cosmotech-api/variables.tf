variable "namespace" {
  type = string
}

variable "monitoring_namespace" {
  type = string
}

variable "api_dns_name" {
  type = string
}

variable "tls_secret_name" {
  type = string
}

variable "redis_admin_password" {
  type = string
}

variable "cosmotech_api_ingress_enabled" {
  type = bool
  default = true
}

variable "redis_port" {
  type    = number
  default = 6379
}

variable "helm_chart" {
  type    = string
  default = "cosmotech-api-chart"
}

variable "helm_repository" {
  type    = string
  default = "oci://ghcr.io/cosmo-tech"
}

variable "cosmotech_api_version" {
  type    = string
  default = "v2"
}

variable "helm_release_name" {
  type    = string
  default = "cosmotech-api-v2"
}

variable "chart_package_version" {
  type    = string
  default = "2.3.5"
}

variable "argo_service_account" {
  type    = string
  default = "workflowcsmv2"
}

variable "argo_release_name" {
  type    = string
  default = "argocsmv2"
}
