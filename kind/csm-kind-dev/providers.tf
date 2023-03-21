terraform {
  required_providers {
    kind = {
      source = "justenwalker/kind"
      version = "0.17.0"
    }
  }
}

provider "kind" {
  provider   = "docker"
  kubeconfig = pathexpand("~/.kube/config")
}