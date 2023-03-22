variable "namespace" {
  type = string
}

variable "monitoring_namespace" {
  type = string
}

variable "argo_release_name" {
  type    = string
  default = "argocsmv2"
}

variable "helm_repo_url" {
  type    = string
  default = "https://argoproj.github.io/argo-helm"
}

variable "helm_chart" {
  type    = string
  default = "argo-workflows"
}

variable "argo_version" {
  type    = string
  default = "0.22.12"
}

variable "argo_service_account" {
  type    = string
  default = "workflowcsmv2"
}

variable "argo_bucket_name" {
  type    = string
  default = "argo-workflows"
}

variable "minio_release_name" {
  type    = string
  default = "miniocsmv2"
}

variable "postgres_release_name" {
  type    = string
  default = "postgrescsmv2"
}

variable "argo_database" {
  type    = string
  default = "argo_workflows"
}

variable "argo_postgresql_secret_name" {
  type    = string
  default = "argo-postgres-config"
}

variable "requeue_time" {
  type    = string
  default = "1s"
}
