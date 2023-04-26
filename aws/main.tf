module "create-cluster" {
  source = "./create-cluster"

  region        = var.region
  cluster_name = var.cluster_name
}
