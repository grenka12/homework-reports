resource "azurerm_log_analytics_workspace" "main-analytics-workspace" {
  name                = "main-analytics-workspace"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
}

resource "azurerm_application_insights" "appinsights" {
  name                = "backend-appins"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
  application_type    = "web"

  workspace_id = azurerm_log_analytics_workspace.main-analytics-workspace.id
}

