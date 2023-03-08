
resource "azurerm_kubernetes_cluster" "phoenixperftestAKS" {
  name                = "phoenixperftestAKS-aks1"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "phoenixperftestAKSaks1"
  kubernetes_version = "1.25.5"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.phoenixperftestAKS.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.phoenixperftestAKS.kube_config_raw

  sensitive = true
}