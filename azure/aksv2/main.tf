data "azuread_group" "owner" {
  display_name = var.owner_group
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.resource_group}-log-analytics"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "PerGB2018"
  retention_in_days   = 60
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
    name            = "system"
    vm_size         = "Standard_A2_v2"
    node_count      = 3
    enable_auto_scaling = true
    min_count       = 3
    max_count       = 6
#    node_taints     = ["CriticalAddonsOnly=true:NoSchedule"]
  }

  identity {
    type = "SystemAssigned"
  }

  tags              = {
    Environment = var.tag
  }

  microsoft_defender {
    log_analytics_workspace_id  = azurerm_log_analytics_workspace.log_analytics.id
  }
}

resource "azurerm_role_assignment" "aks-owner" {
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
  max_count       = 5
  node_labels     = {
    "cosmotech.com/tier"  = "services"
  }
  node_taints     = ["vendor=cosmotech:NoSchedule"]
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
  vm_size         = "Standard_D2ads_v5"
  node_count      = 2
  enable_auto_scaling = true
  min_count       = 2
  max_count       = 3
  node_labels     = {
    "cosmotech.com/tier"  = "db"
  }
  node_taints     = ["vendor=cosmotech:NoSchedule"]
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "standard" {
  name                  = "cstandard"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  mode            = "User"
  vm_size         = var.standard_sizing
  node_count      = 1
  enable_auto_scaling = true
  min_count       = 1
  max_count       = 4
  node_labels     = {
    "cosmotech.com/tier"  = "compute"
    "cosmotech.com/size"  = "basic"
  }
  node_taints     = ["vendor=cosmotech:NoSchedule"]
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "highcpu" {
  name                  = "chighcpu"
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
  node_taints     = ["vendor=cosmotech:NoSchedule"]
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "highmemory" {
  name                  = "highmemory"
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
  node_taints     = ["vendor=cosmotech:NoSchedule"]
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

resource "azurerm_managed_disk" "redis-master-disk" {
  name                 = "csmredismaster"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "64"

  tags = {
    environment = var.tag
  }
}

resource "azurerm_role_assignment" "aks-redis-master" {
  scope                = azurerm_managed_disk.redis-master-disk.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "azurerm_managed_disk" "redis-replica1-disk" {
  name                 = "csmredisreplica1"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "64"

  tags = {
    environment = var.tag
  }
}

resource "azurerm_role_assignment" "aks-redis-replica1" {
  scope                = azurerm_managed_disk.redis-replica1-disk.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}


output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw

  sensitive = true
}

# V1 stack
resource "azurerm_kubernetes_cluster_node_pool" "basicpool" {
  count = var.deploy_v1 ? 1 : 0
  name                  = "basicpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  mode            = "User"
  vm_size         = "Standard_F8s_v2"
  node_count      = 1
  enable_auto_scaling = true
  min_count       = 1
  max_count       = 3
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "highcpupool" {
  count = var.deploy_v1 ? 1 : 0
  name                  = "highcpupool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  mode            = "User"
  vm_size         = "Standard_F72s_v2"
  node_count      = 0
  enable_auto_scaling = true
  min_count       = 0
  max_count       = 1
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "memorypool" {
  count = var.deploy_v1 ? 1 : 0
  name                  = "memorypool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  mode            = "User"
  vm_size         = "Standard_E16ads_v5"
  node_count      = 0
  enable_auto_scaling = true
  min_count       = 0
  max_count       = 1
  os_type         = "Linux"
  os_sku          = "Ubuntu"

  tags          = {
    Environment = var.tag
  }
}

