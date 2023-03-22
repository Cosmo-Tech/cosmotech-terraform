variable "helm_repo_url" {
  type    = string
  default = "https://kubernetes.github.io/ingress-nginx"
}

variable "helm_release_name" {
  type    = string
  default = "ingress-nginx"
}

variable "ingress_nginx_version" {
  type    = string
  default = "4.2.5"
}

variable "namespace" {
  type = string
}

variable "monitoring_namespace" {
  type = string
}

variable "loadbalancer_ip" {
  type = string
}

variable "tls_secret_name" {
  type = string
}
