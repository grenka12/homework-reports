# resource "azurerm_key_vault_secret" "sql_admin_password" {
#   name         = "sql-admin-password"
#   value        = var.db-password
#   key_vault_id = azurerm_key_vault.main-keyvault.id
# }