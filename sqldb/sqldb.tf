resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_mssql_server" "example" {
  name                         = "plicsql"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = "East US"
  version                      = "12.0"
  administrator_login          = "radhika"
  administrator_login_password = "Radhilatha@9"
}

resource "azurerm_storage_account" "example" {
  name                     = "plihjysa"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_database" "example" {
  name                = "plicsqldb"
  server_id           = azurerm_mssql_server.example.id
  max_size_gb         = 4
  read_scale          = true
  sku_name            = "BC_Gen5_2"
  zone_redundant      = true
}