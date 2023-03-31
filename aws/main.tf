module "create-cluster" {
  source = "./create-cluster"

  region        = var.region
  cluster_name = var.cluster_name
  # access_key    = var.access_key
  # access_secret = var.access_secret
}
