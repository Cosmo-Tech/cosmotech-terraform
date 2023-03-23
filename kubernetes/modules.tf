module "create-ingress-nginx" {
  source = "./create-ingress-nginx"

  namespace             = var.namespace
  monitoring_namespace  = var.monitoring_namespace
  ingress_nginx_version = var.ingress_nginx_version
  loadbalancer_ip       = var.loadbalancer_ip
  tls_secret_name       = var.tls_secret_name

  # depends_on = [
  #   module.create-prometheus-stack
  # ]
}

module "create-prometheus-stack" {
  source               = "./create-prometheus-stack"
  namespace            = var.namespace
  monitoring_namespace = var.monitoring_namespace
  api_dns_name         = var.api_dns_name
  tls_secret_name      = var.tls_secret_name
  redis_admin_password = random_password.redis_admin_password.result
  prom_admin_password  = random_password.prom_admin_password.result

  depends_on = [
    module.cert-manager
  ]
}

module "cert-manager" {
  source  = "terraform-iaac/cert-manager/kubernetes"
  version = "2.5.0"

  namespace_name       = var.namespace
  create_namespace     = false
  cluster_issuer_email = var.cluster_issuer_email
  cluster_issuer_name  = var.cluster_issuer_name
}

module "create-redis-stack" {
  source = "./create-redis-stack"

  redis_admin_password = random_password.redis_admin_password.result
  namespace            = var.namespace
  resource_group       = var.resource_group
}

module "create-minio" {
  source = "./create-minio"

  namespace             = var.namespace
  monitoring_namespace  = var.monitoring_namespace
  argo_minio_access_key = random_password.argo_minio_access_key.result
  argo_minio_secret_key = random_password.argo_minio_secret_key.result
}

module "create-postgresql-db" {
  source = "./create-postgresql-db"

  namespace                = var.namespace
  monitoring_namespace     = var.monitoring_namespace
  argo_postgresql_password = random_password.argo_postgresql_password.result
}

module "create-argo" {
  source = "./create-argo"

  namespace            = var.namespace
  monitoring_namespace = var.monitoring_namespace
}

module "create-cosmotech-api" {
  source = "./create-cosmotech-api"

  namespace            = var.namespace
  monitoring_namespace = var.monitoring_namespace
  api_dns_name         = var.api_dns_name
  tls_secret_name      = var.tls_secret_name
  redis_admin_password = random_password.redis_admin_password.result
}