
resource "random_pet" "prefix" {}


data "azurerm_resource_group" "default" {
  name = "rg-c2s-internal-srikanthk"
  #location = "West US"
}


resource "azurerm_container_registry" "acr" {
  name                = "SrikanthRegistry78654"
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location
  sku                 = "Standard"
  admin_enabled       = false
  
}

resource "azurerm_kubernetes_cluster" "default" {
  name               = "${random_pet.prefix.id}-k8s"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"
  kubernetes_version = "1.29.2"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }



}
