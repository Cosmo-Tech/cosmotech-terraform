variable "resource_group" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "tenant_id" {
  description = "The tenant id"
}

variable "subscription_id" {
  description = "The subscription id"
}

variable "client_id" {
  description = "The client id"
}

variable "client_secret" {
  description = "The client secret"
}

variable "resource_group_name" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = ""
}

variable "cosmotech_api" {
  type = map(string)
  default = {
    "API_VERSION"                = "",
    "COSMOTECH_API_RELEASE_NAME" = "",
    "COSMOTECH_API_DNS_NAME"     = ""
  }
}

variable "nginx_resource" {
  type = map(string)
  default = {
    "NGINX_INGRESS_CONTROLLER_LOADBALANCER_IP"         = "",
    "NGINX_INGRESS_CONTROLLER_HELM_ADDITIONAL_OPTIONS" = ""
  }
}

variable "argo_resources" {
  type = map(string)
  default = {
    # Both values below can be automatically generated
    "ARGO_MINIO_ACCESS_KEY" = "",
    "ARGO_MINIO_SECRET_KEY" = "",
  }
}

variable "prometheus_stack_vars" {
  type = map(string)
  default = {
    "PROM_ADMIN_PASSWORD_VAR" = ""
  }
}

variable "redis_resource_vars" {
  type = map(string)
  default = {
    "REDIS_ADMIN_PASSWORD" = ""
  }
}

variable "ingress_nginx_version" {
  type    = string
  default = "4.2.1"
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

variable "redis_admin_password" {
  type = string
}

variable "prom_admin_password" {
  type = string
}

variable "cluster_issuer_email" {
  type = string
}

variable "cluster_issuer_name" {
  type = string
}
# export HELM_EXPERIMENTAL_OCI=1

# export CHART_PACKAGE_VERSION="$1"
# export API_VERSION="$4"
# export REQUEUE_TIME="${ARGO_REQUEUE_TIME:-1s}"

# echo CHART_PACKAGE_VERSION: "$CHART_PACKAGE_VERSION"
# echo API_VERSION: "$API_VERSION"

# export ARGO_VERSION="0.16.6"
# export ARGO_RELEASE_NAME=argocsmv2
# export ARGO_RELEASE_NAMESPACE="${NAMESPACE}"
# export MINIO_VERSION="12.1.3"
# export MINIO_RELEASE_NAME=miniocsmv2
# export POSTGRES_RELEASE_NAME=postgrescsmv2
# export POSTGRESQL_VERSION="11.6.12"
# export ARGO_POSTGRESQL_USER=argo
# export ARGO_POSTGRESQL_PASSWORD="$3"
# export CERT_MANAGER_VERSION="1.9.1"
# export VERSION_REDIS="17.3.14"
# export VERSION_REDIS_COSMOTECH="1.0.2"
# export VERSION_REDIS_INSIGHT="0.1.0"
# export PROMETHEUS_STACK_VERSION="45.0.0"

# export ARGO_DATABASE=argo_workflows
# export ARGO_BUCKET_NAME=argo-workflows

# WORKING_DIR=$(mktemp -d -t cosmotech-api-helm-XXXXXXXXXX)
# echo "[info] Working directory: ${WORKING_DIR}"
# pushd "${WORKING_DIR}"

# echo -- "[info] Working directory: ${WORKING_DIR}"

# # common exports
# export COSMOTECH_API_RELEASE_NAME="cosmotech-api-${API_VERSION}"
# export REDIS_PORT=6379
