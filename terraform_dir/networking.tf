# resource "azurerm_private_endpoint" "backend-ep" {
#   name                = "backend-ep"
#   location            = azurerm_resource_group.rg-main.location
#   resource_group_name = azurerm_resource_group.rg-main.name
#   subnet_id           = azurerm_subnet.backend-subnet-ib.id

#   private_service_connection {
#     name                           = "backend-ep-psc"
#     private_connection_resource_id = azurerm_linux_web_app.Backend-webapp.id
#     subresource_names              = ["sites"]
#     is_manual_connection           = false
#   }

#   private_dns_zone_group {
#     name                 = "serviceApp-dns-zg"
#     private_dns_zone_ids = [azurerm_private_dns_zone.serviceApp-dns.id]
#   }
# }

resource "azurerm_private_endpoint" "storage-pe" {
  name                = "storage-pe"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
  subnet_id           = azurerm_subnet.storage-subnet.id

  private_service_connection {
    name                           = "storage-sa-psc"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-dns-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage-dns.id]
  }
}

resource "azurerm_private_endpoint" "keyvault-pe" {
  name                = "keyvault-pe"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
  subnet_id           = azurerm_subnet.keyvault-subnet.id

  private_service_connection {
    name                           = "keyvault-sa-psc"
    private_connection_resource_id = azurerm_key_vault.main-keyvault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "keyvault-dns-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault-dns.id]
  }
}

resource "azurerm_private_endpoint" "sqlServer-pe" {
  name                = "sqlServer-pe"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
  subnet_id           = azurerm_subnet.sqlServer-subnet.id

  private_service_connection {
    name                           = "sqlServer-sa-psc"
    private_connection_resource_id = azurerm_mssql_server.msql-server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sqlServer-dns-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.sqlServer-dns.id]
  }
}

resource "azurerm_private_endpoint" "acr-pe" {
  name                = "acr-pe"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
  subnet_id           = azurerm_subnet.acr-subnet.id

  private_service_connection {
    name                           = "acr-psc"
    private_connection_resource_id = azurerm_container_registry.backend-acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "acr-dns-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_dns.id]
  }
}




resource "azurerm_virtual_network" "backend-vnet" {
  name                = "backend-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
}

# resource "azurerm_subnet" "backend-subnet-ib" {
#   name                 = "backend-subnet-inbound"
#   resource_group_name  = azurerm_resource_group.rg-main.name
#   virtual_network_name = azurerm_virtual_network.backend-vnet.name
#   address_prefixes     = ["10.0.1.0/24"]

# }

resource "azurerm_subnet" "backend-subnet-ob" {
  name                 = "backend-subnet-outbound"
  resource_group_name  = azurerm_resource_group.rg-main.name
  virtual_network_name = azurerm_virtual_network.backend-vnet.name
  address_prefixes     = ["10.0.6.0/23"]
}

resource "azurerm_subnet" "storage-subnet" {
  name                 = "storage-subnet"
  resource_group_name  = azurerm_resource_group.rg-main.name
  virtual_network_name = azurerm_virtual_network.backend-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "keyvault-subnet" {
  name                 = "keyvault-subnet"
  resource_group_name  = azurerm_resource_group.rg-main.name
  virtual_network_name = azurerm_virtual_network.backend-vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_subnet" "sqlServer-subnet" {
  name                 = "sqlServer-subnet"
  resource_group_name  = azurerm_resource_group.rg-main.name
  virtual_network_name = azurerm_virtual_network.backend-vnet.name
  address_prefixes     = ["10.0.5.0/24"]
}

resource "azurerm_subnet" "acr-subnet" {
  name                 = "acr-subnet"
  resource_group_name  = azurerm_resource_group.rg-main.name
  virtual_network_name = azurerm_virtual_network.backend-vnet.name
  address_prefixes     = ["10.0.8.0/24"]
}