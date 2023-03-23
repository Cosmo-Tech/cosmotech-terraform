variable "resource_group" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "tenant_id" {
  type        = string
  description = "The tenant id"
}

variable "subscription_id" {
  type        = string
  description = "The subscription id"
}

variable "client_id" {
  type        = string
  description = "The client id"
}

variable "client_secret" {
  type        = string
  description = "The client secret"
}

variable "location" {
  type    = string
  default = ""
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

variable "api_dns_name" {
  type = string
}

variable "cluster_issuer_email" {
  type = string
}

variable "cluster_issuer_name" {
  type = string
}

variable "ingress_nginx_version" {
  type    = string
  default = "4.2.1"
}

# variable "redis_admin_password" {
#   type = string
# }

# variable "argo_postgresql_password" {
#   type = string
# }

# variable "argo_minio_access_key" {
#   type = string
# }

# variable "argo_minio_secret_key" {
#   type = string
# }

# variable "prom_admin_password" {
#   type = string
# }
