  resource "azurerm_private_dns_zone" "storage-dns" {
    name                = "privatelink.file.core.windows.net"
    resource_group_name = azurerm_resource_group.rg-main.name
  }

  resource "azurerm_private_dns_zone_virtual_network_link" "storage-dns-link" {
    name                  = "storage-dns-link"
    resource_group_name   = azurerm_resource_group.rg-main.name
    private_dns_zone_name = azurerm_private_dns_zone.storage-dns.name
    virtual_network_id    = azurerm_virtual_network.backend-vnet.id
  }



  # resource "azurerm_private_dns_zone" "serviceApp-dns" {
  #   name                = "privatelink.azurewebsites.net"
  #   resource_group_name = azurerm_resource_group.rg-main.name
  # }

  # resource "azurerm_private_dns_zone_virtual_network_link" "serviceApp-dns-link" {
  #   name                  = "storage-dns-link"
  #   resource_group_name   = azurerm_resource_group.rg-main.name
  #   private_dns_zone_name = azurerm_private_dns_zone.serviceApp-dns.name
  #   virtual_network_id    = azurerm_virtual_network.backend-vnet.id
  # }



  resource "azurerm_private_dns_zone" "keyvault-dns" {
    name                = "privatelink.vault.azure.net"
    resource_group_name = azurerm_resource_group.rg-main.name
  }

  resource "azurerm_private_dns_zone_virtual_network_link" "keyvault-dns-link" {
    name                  = "keyvault-dns-link"
    resource_group_name   = azurerm_resource_group.rg-main.name
    private_dns_zone_name = azurerm_private_dns_zone.keyvault-dns.name
    virtual_network_id    = azurerm_virtual_network.backend-vnet.id
  }


  resource "azurerm_private_dns_zone" "sqlServer-dns" {
    name                = "privatelink.database.windows.net"
    resource_group_name = azurerm_resource_group.rg-main.name
  }

  resource "azurerm_private_dns_zone_virtual_network_link" "sqlServer-dns-link" {
    name                  = "sqlServer-dns-link"
    resource_group_name   = azurerm_resource_group.rg-main.name
    private_dns_zone_name = azurerm_private_dns_zone.sqlServer-dns.name
    virtual_network_id    = azurerm_virtual_network.backend-vnet.id
  }

  resource "azurerm_private_dns_zone" "acr_dns" {
    name                = "privatelink.azurecr.io"
    resource_group_name = azurerm_resource_group.rg-main.name
  }

  resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_link" {
    name                  = "acr-dns-link"
    resource_group_name   = azurerm_resource_group.rg-main.name
    private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
    virtual_network_id    = azurerm_virtual_network.backend-vnet.id
  }
