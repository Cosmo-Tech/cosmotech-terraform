variable "cluster_name" {
  type = string
  default = "kind-local-k8s-cluster"
}

// https://hub.docker.com/r/kindest/node/tags
variable "cluster_version" {
    type = string
    default = "v1.25.3"
}