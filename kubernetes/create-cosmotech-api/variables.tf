variable "helm_repo_url" {
  type    = string
  default = "https://prometheus-community.github.io/helm-charts"
}

variable "helm_release_name" {
  type    = string
  default = "prometheus-community"
}

variable "cosmotech_api_version" {
  type    = string
  default = ""
}
