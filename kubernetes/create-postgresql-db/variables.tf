variable "monitoring_namespace" {
  type = string
}

variable "argo_database" {
  type = string
}

variable "argo_postgresql_password" {
  type = string
}

variable "argo_postgresql_user" {
  type = string
}

variable "helm_repo_url" {
  type    = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "helm_chart" {
  type    = string
  default = "bitnami/postgresql"
}

variable "postgresql_version" {
  type    = string
  default = "11.6.12"
}

variable "helm_release_name" {
  type = string
  default = "postgrescsmv2"
}