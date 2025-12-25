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

// 2.
resource "azurerm_container_app_environment" "backend-cae" {
  name                = "backend-cae"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name

  log_analytics_workspace_id = azurerm_log_analytics_workspace.main-analytics-workspace.id

  infrastructure_subnet_id = azurerm_subnet.backend-subnet-ob.id
}
// 1.
resource "azurerm_container_app" "backend" {
  name                         = "backend-capp"
  container_app_environment_id = azurerm_container_app_environment.backend-cae.id
  resource_group_name          = azurerm_resource_group.rg-main.name
  revision_mode                = "Single"

 #whoami
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.backend-mi.id]
  }


  ingress {

    external_enabled = false

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
    target_port = var.backend-ingress-port
  }

  template {
  volume {
    name         = "uploads"
    storage_name = azurerm_container_app_environment_storage.files.name
    storage_type = "AzureFile"
  }

  container {
    name   = "realease"
    image  = "${azurerm_container_registry.backend-acr.login_server}/backend:latest"
    cpu    = 0.25
    memory = "0.5Gi"


    volume_mounts {
      path  = "/mnt/files"
      name  = "uploads"
    }
  }
}

  registry {
    server   = azurerm_container_registry.backend-acr.login_server
    identity = azurerm_user_assigned_identity.backend-mi.id
  }

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

  public_network_access_enabled = true
}

# data "azurerm_key_vault_secret" "db_password" {
#   name         = "db-password"
#   key_vault_id = azurerm_key_vault.main-keyvault.id
# }


resource "azurerm_mssql_server" "msql-server" {
  name                = "mssql-db-server-1"
  resource_group_name = azurerm_resource_group.rg-main.name
  location            = azurerm_resource_group.rg-main.location
  version             = "12.0"

  public_network_access_enabled = false
  administrator_login           = var.db-username
  administrator_login_password  = var.db_password #data.azurerm_key_vault_secret.db_password.value

}


resource "azurerm_mssql_database" "main" {
  name      = var.db-name
  server_id = azurerm_mssql_server.msql-server.id
  storage_account_type = "Local"

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

resource "azurerm_container_app_environment_storage" "files" {
  name                         = "fileshare"
  access_mode = "ReadWrite"
  container_app_environment_id = azurerm_container_app_environment.backend-cae.id

  account_name = azurerm_storage_account.storage.name
  share_name   = azurerm_storage_share.name.name
  access_key   = azurerm_storage_account.storage.primary_access_key
}
