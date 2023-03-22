variable "helm_repo_url" {
  type    = string
  default = "https://charts.jetstack.io"
}

variable "helm_release_name" {
  type    = string
  default = "jetstack"
}

variable "cert_manager_version" {
  type    = string
  default = "1.9.1"
}

variable "namespace" {
  type = string
}

variable "monitoring_namespace" {
  type = string
}

variable "tls_secret_name" {
  type = string
}