resource "azurerm_container_registry" "backend-acr" {
  name                = "backendACR"
  resource_group_name = azurerm_resource_group.rg-main.name
  location            = azurerm_resource_group.rg-main.location
  sku                 = "Premium"

  public_network_access_enabled = false
}

