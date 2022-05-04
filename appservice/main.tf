resource "azurerm_resource_group" "simpleapp" {
  name     = var.rgname
  location = var.location
}

resource "azurerm_app_service_plan" "simpleappplan" {
  name                = var.serviceplan
  location            = azurerm_resource_group.simpleapp.location
  resource_group_name = azurerm_resource_group.simpleapp.name
  kind                = "Linux"
  reserved            = true
  
  sku {
    tier = "Standard"
    size = "S1"
  }
}
resource "azurerm_mssql_server" "mssqlserver" {
  name                = var.mssqlname
  location            = azurerm_resource_group.simpleapp.location
  resource_group_name = azurerm_resource_group.simpleapp.name
  administrator_login          = var.username
  administrator_login_password = var.password
  version    = "12.0"
}
resource "azurerm_app_service" "simpleappser" {
  name                = var.service
  location            = azurerm_resource_group.simpleapp.location
  resource_group_name = azurerm_resource_group.simpleapp.name
  app_service_plan_id = azurerm_app_service_plan.simpleappplan.id

  site_config {
    linux_fx_version = "PYTHON|3.7"
    use_32_bit_worker_process = false
    scm_type                 = "LocalGit"
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }

  connection_string {
    name  = "appserver"
    type  = "SQLServer"
    value = "Server=azurerm_mssql_server.mssqlserver.database.linux.net;Integrated Security=SSPI"
  }
}