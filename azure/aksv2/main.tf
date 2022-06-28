data "azuread_group" "owner" {
  display_name = var.owner_group
}

resource "azurerm_kubernetes_cluster" "aks" {
  name              = var.aks_name
  location          = var.location
  resource_group_name = var.resource_group
  azure_policy_enabled  = true
  kubernetes_version  = var.k8s_version
  dns_prefix         = var.aks_name
  network_profile {
    network_plugin  = "kubenet"
    network_policy  = "calico"
    outbound_type   = "loadBalancer"
    load_balancer_sku = "standard"
  }
  sku_tier          = "Paid"
  default_node_pool {
    name            = "systempool"
    vm_size         = "Standard_A2_v2"
    node_count      = 2
    enable_auto_scaling = true
    min_count       = 2
    max_count       = 6
  }

  identity {
    type = "SystemAssigned"
  }

  tags              = {
    Environment = var.tag
  }
}

resource "azurerm_role_assignment" "aks_owner" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_group.owner.object_id
}

resource "azurerm_kubernetes_cluster_node_pool" "services" {
  name                  = "services"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  mode            = "User"
  vm_size         = "Standard_B2s"
  node_count      = 2
  enable_auto_scaling = true
  min_count       = 2
  max_count       = 4
  node_labels     = {
    "cosmotech.com/tier"  = "services"
  }
#  node_taints     = ["vendor=cosmotech:NoSchedule"]
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "db" {
  name                  = "db"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  mode            = "User"
  vm_size         = "Standard_A2_v2"
  node_count      = 2
  enable_auto_scaling = true
  min_count       = 2
  max_count       = 4
  node_labels     = {
    "cosmotech.com/tier"  = "db"
  }
#  node_taints     = ["vendor=cosmotech:NoSchedule"]
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "basicpool" {
  name                  = "basicpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  mode            = "User"
  vm_size         = "Standard_F4s_v2"
  node_count      = 0
  enable_auto_scaling = true
  min_count       = 0
  max_count       = 4
  node_labels     = {
    "cosmotech.com/tier"  = "compute"
    "cosmotech.com/size"  = "basic"
  }
#  node_taints     = ["vendor=cosmotech:NoSchedule"]
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "highcpupool" {
  name                  = "highcpupool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  mode            = "User"
  vm_size         = "Standard_F72s_v2"
  node_count      = 0
  enable_auto_scaling = true
  min_count       = 0
  max_count       = 2
  node_labels     = {
    "cosmotech.com/tier"  = "compute"
    "cosmotech.com/size"  = "highcpu"
  }
#  node_taints     = ["vendor=cosmotech:NoSchedule"]
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "memorypool" {
  name                  = "memorypool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  mode            = "User"
  vm_size         = "Standard_E16ads_v5"
  node_count      = 0
  enable_auto_scaling = true
  min_count       = 0
  max_count       = 2
  node_labels     = {
    "cosmotech.com/tier"  = "compute"
    "cosmotech.com/size"  = "highmemory"
  }
#  node_taints     = ["vendor=cosmotech:NoSchedule"]
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw

  sensitive = true
}
