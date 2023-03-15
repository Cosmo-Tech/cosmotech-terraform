
resource "azurerm_kubernetes_cluster" "phoenixperftestAKS" {
  name                = "phoenixperftestAKS-aks1"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "phoenixperftestAKSaks1"
  kubernetes_version  = "1.25.5"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "system" {
  name                  = "system"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixperftestAKS.id
  vm_size               = "Standard_A2_v2"
  node_count            = 4
  max_pods              = 110
  max_count             = 6
  min_count             = 3
  enable_auto_scaling   = true
  mode                  = "System"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
}

resource "azurerm_kubernetes_cluster_node_pool" "basic" {
  name                  = "basic"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixperftestAKS.id
  vm_size               = "Standard_F4s_v2"
  node_count            = 2
  max_pods              = 110
  max_count             = 5
  min_count             = 1
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "compute", "cosmotech.com/size" = "basic" }
}

resource "azurerm_kubernetes_cluster_node_pool" "highcpu" {
  name                  = "highcpu"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixperftestAKS.id
  vm_size               = "Standard_F72s_v2"
  node_count            = 0
  max_pods              = 110
  max_count             = 3
  min_count             = 0
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "compute", "cosmotech.com/size" = "highcpu" }
}

resource "azurerm_kubernetes_cluster_node_pool" "highmemory" {
  name                  = "highmemory"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixperftestAKS.id
  vm_size               = "Standard_E16ads_v5"
  node_count            = 0
  max_pods              = 110
  max_count             = 3
  min_count             = 0
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "compute", "cosmotech.com/size" = "highmemory" }
}

resource "azurerm_kubernetes_cluster_node_pool" "services" {
  name                  = "services"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixperftestAKS.id
  vm_size               = "Standard_A2m_v2"
  node_count            = 2
  max_pods              = 110
  max_count             = 5
  min_count             = 2
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "services" }
}

resource "azurerm_kubernetes_cluster_node_pool" "db" {
  name                  = "db"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixperftestAKS.id
  vm_size               = "Standard_D2ads_v5"
  node_count            = 2
  max_pods              = 110
  max_count             = 5
  min_count             = 2
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "db" }
}

resource "azurerm_kubernetes_cluster_node_pool" "monitoring" {
  name                  = "monitoring"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.phoenixperftestAKS.id
  vm_size               = "Standard_D2ads_v5"
  node_count            = 0
  max_pods              = 110
  max_count             = 10
  min_count             = 0
  enable_auto_scaling   = true
  mode                  = "User"
  os_type               = "Linux"
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  node_taints           = ["vendor=cosmotech:NoSchedule"]
  node_labels           = { "cosmotech.com/tier" = "monitoring" }
}

resource "azurerm_managed_disk" "cosmotech-database-disk" {
  name = "cosmotech-database-disk"
  resource_group_name = var.resource_group
  disk_size_gb = var.disk_size_gb
  location = var.location
  storage_account_type = var.disk_sku
  tier = var.disk_tier
}