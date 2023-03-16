variable "namespace" {
  type = string
}

variable "monitoring_namespace" {
  type = string
}

variable "argo_minio_access_key" {
  type = string
}

variable "argo_minio_secret_key" {
  type = string
}

variable "helm_repo_url" {
  type    = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "minio_release_name" {
  type    = string
  default = "miniocsmv2"
}

variable "helm_chart" {
  type = string
  default = "minio"
}

variable "minio_version" {
  type    = string
  default = "12.1.3"
}

variable "argo_bucket_name" {
  type = string
  default = "argo-workflows"
}

variable "argo_minio_persistence_size" {
  type = string
  default = "16Gi"
}

variable "argo_minio_requests_memory" {
  type = string
  default = "2Gi"
}

