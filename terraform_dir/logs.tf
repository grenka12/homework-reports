resource "azurerm_log_analytics_workspace" "main-analytics-workspace" {
  name                = "main-analytics-workspace"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
}

# resource "azurerm_application_insights" "appinsights" {
#   name                = "backend-appins"
#   location            = azurerm_resource_group.rg-main.location
#   resource_group_name = azurerm_resource_group.rg-main.name
#   application_type    = "web"

#   workspace_id = azurerm_log_analytics_workspace.main-analytics-workspace.id
# }

# resource "azurerm_monitor_diagnostic_setting" "backend_logs" {
#   name                       = "backend-logs"
#   target_resource_id         = azurerm_linux_web_app.Backend-webapp.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.main-analytics-workspace.id

#   enabled_log {
#     category = "AppServiceHTTPLogs"
#   }

#   enabled_log {
#     category = "AppServiceConsoleLogs"
#   }

#   enabled_log {
#     category = "AppServiceAppLogs"
#   }

#   enabled_metric {
#     category = "AllMetrics"
#   }
# }

