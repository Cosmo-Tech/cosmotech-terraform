module "create-loki" {
  source = "./create-loki"

  namespace        = var.namespace
  retention_period = var.retention_period
}