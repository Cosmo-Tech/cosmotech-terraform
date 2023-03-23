locals {
  values_cosmotech_api = {
    "MONITORING_NAMESPACE"          = var.monitoring_namespace
    "CHART_PACKAGE_VERSION"         = var.chart_package_version
    "TLS_SECRET_NAME"               = var.tls_secret_name
    "NAMESPACE"                     = var.namespace
    "REDIS_PORT"                    = var.redis_port
    "REDIS_PASSWORD"                = var.redis_admin_password
    "ARGO_SERVICE_ACCOUNT"          = var.argo_service_account
    "ARGO_RELEASE_NAME"             = var.argo_release_name
    "COSMOTECH_API_INGRESS_ENABLED" = var.cosmotech_api_ingress_enabled
    "COSMOTECH_API_DNS_NAME"        = var.api_dns_name
    "API_VERSION"                   = var.cosmotech_api_version
  }
}

resource "helm_release" "cosmotech-api" {
  name       = var.helm_release_name
  repository = var.helm_repository
  chart      = var.helm_chart
  version    = var.chart_package_version
  namespace  = var.namespace

  reuse_values = true

  values = [
    templatefile("${path.module}/values.yaml", local.values_cosmotech_api)
  ]
}
