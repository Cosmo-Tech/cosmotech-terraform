variable "helm_repo_url" {
  type    = string
  default = "https://prometheus-community.github.io/helm-charts"
}

variable "helm_release_name" {
  type    = string
  default = ""
}

variable "cosmotech_api_version" {
  type    = string
  default = ""
}

variable "chart_package_version" {
  type = string
}

variable "argo_service_account" {
  type = string
  default = "workflowcsmv2"
}

variable "argo_release_name" {
  type = string
  default = "argocsmv2"
}

variable "api_dns_name" {
  type = string
}