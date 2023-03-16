variable "namespace" {
  type = string
}

variable "monitoring_namespace" {
  type = string
}

variable "argo_postgresql_password" {
  type = string
}

variable "argo_postgresql_user" {
  type = string
  default = "argo"
}

variable "argo_postgresql_secret_name" {
  type = string
  default = "argo-postgres-config"
}

variable "argo_database" {
  type = string
  default = "argo_workflows"
}

variable "helm_repo_url" {
  type    = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "helm_chart" {
  type    = string
  default = "postgresql"
}

variable "postgresql_version" {
  type    = string
  default = "11.6.12"
}

variable "helm_release_name" {
  type = string
  default = "postgrescsmv2"
}