variable "cluster_name" {
  type = string
  default = "kind-local-k8s-cluster"
}
variable "namespace" {
  type = string
  default = "phoenix"
}

variable "monitoring_namespace" {
  type = string
  default = "phoenix-monitoring"
}


