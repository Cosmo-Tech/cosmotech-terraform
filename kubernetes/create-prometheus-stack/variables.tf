variable "prom_storage_resource_request" {
  type = string
  default = "64Gi"
}

variable "prom_storage_class_name" {
  type = string
  default = "default"
}

variable "prom_cpu_mem_limits" {
  type = string
  default = "2Gi"
}

variable "prom_cpu_mem_request" {
  type = string
  default = "2Gi"
}

variable "prom_replicas_number" {
  type = string
  default = "1"
}

variable "redis_port" {
  type = number
  default = 6379
}

variable "helm_repo_url" {
  type = string
  default = "https://prometheus-community.github.io/helm-charts"
}

variable "helm_release_name" {
  type = string
  default = "prometheus-community"
}

variable "prometheus_stack_version" {
  type = string
  default = "45.0.0"
}

variable "redis_admin_password" {
  type = string
}

variable "prom_admin_password" {
  type = string
}