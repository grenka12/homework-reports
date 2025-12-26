//locals { app_identity = azurerm_linux_web_app.Backend-webapp.identity[0].principal_id }


resource "azurerm_key_vault_access_policy" "backend_app" {
  key_vault_id = azurerm_key_vault.main-keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.backend-mi.principal_id

  secret_permissions = ["Get", "List"]
}




resource "azurerm_user_assigned_identity" "backend-mi" {
  name                = "backend-mi"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
}


#
#НАДА
#

# resource "azurerm_role_assignment" "acrpull_assignment" {
#   scope                = azurerm_container_registry.backend-acr.id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_user_assigned_identity.backend-mi.principal_id
# }

# resource "azurerm_role_assignment" "kv_secrets_assignmentt" {
#   scope                = azurerm_key_vault.main-keyvault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_user_assigned_identity.backend-mi.principal_id
# }

# resource "azurerm_role_assignment" "storage_files_assignments" {
#   scope                = azurerm_storage_account.storage.id
#   role_definition_name = "Storage File Data SMB Share Contributor"
#   principal_id         = azurerm_user_assigned_identity.backend-mi.principal_id
# }


resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = "westeurope"
}
