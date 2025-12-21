terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
  }

  required_version = ">= 1.13.3"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "bestrongtfstate1"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg-main" {
  name     = "backendrg-main"
  location = "polandcentral"
}

resource "azurerm_service_plan" "Backend-sp" {
  name                = "Backend-sp"
  resource_group_name = azurerm_resource_group.rg-main.name
  location            = azurerm_resource_group.rg-main.location
  os_type             = "Linux"
  sku_name            = "B3"
}

resource "azurerm_linux_web_app" "Backend-webapp" {
  name                          = var.appservice-name
  resource_group_name           = azurerm_resource_group.rg-main.name
  location                      = azurerm_service_plan.Backend-sp.location
  service_plan_id               = azurerm_service_plan.Backend-sp.id
  public_network_access_enabled = false
  virtual_network_subnet_id     = azurerm_subnet.backend-subnet-ob.id

  //logs
  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.appinsights.connection_string
  }

  identity {
  type = "SystemAssigned"
}

  site_config {}
}

//


//
// 3. Key vault
//

resource "azurerm_key_vault" "main-keyvault" {
  name                = var.keyvault-name
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  public_network_access_enabled = false
}


resource "azurerm_mssql_server" "msql-server" {
  name                = "mssql-db-server-1"
  resource_group_name = azurerm_resource_group.rg-main.name
  location            = azurerm_resource_group.rg-main.location
  version             = "12.0"

  public_network_access_enabled = false
  administrator_login           = var.db-username
  administrator_login_password  = var.db-password
  
  #   azuread_administrator {
  #     azuread_authentication_only = true
  #     login_username = "psql-admin"
  #     object_id = azuread_group.sql_admins.object_id
  #   }
}


resource "azurerm_storage_account" "storage" {
  name                     = "bestrongstorage1"
  resource_group_name      = azurerm_resource_group.rg-main.name
  location                 = azurerm_resource_group.rg-main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = false
}

resource "azurerm_storage_share" "name" {
  name               = "main-fileshare-bestrongstorage"
  storage_account_id = azurerm_storage_account.storage.id
  quota              = 100
}