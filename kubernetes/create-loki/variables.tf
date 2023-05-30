variable "namespace" {
  type = string
}

variable "loki_release_name" {
  type    = string
  default = "loki"
}

variable "retention_period" {
  type    = string
  default = "720h"
}

variable "helm_repo_url" {
  type    = string
  default = "https://grafana.github.io/helm-charts"
}

variable "helm_chart" {
  type    = string
  default = "loki-stack"
}