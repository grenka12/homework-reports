locals { app_identity = azurerm_linux_web_app.Backend-webapp.identity[0].principal_id }

# resource "azurerm_role_assignment" "kv_secrets" {
#   scope                = azurerm_key_vault.main-keyvault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = local.app_identity
# }

# resource "azurerm_role_assignment" "storage_files" {
#   scope                = azurerm_storage_account.storage.id
#   role_definition_name = "Storage File Data SMB Share Contributor"
#   principal_id         = local.app_identity
# }

# resource "azurerm_role_assignment" "acr-assignment" {
#   scope                = azurerm_container_registry.backend-acr.id
#   role_definition_name = "AcrPull"
#   principal_id         = local.app_identity
# }







# resource "azurerm_role_assignment" "kv_admin_for_tf" {
#   scope                = azurerm_key_vault.main-keyvault.id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = data.azurerm_client_config.current.object_id
# }