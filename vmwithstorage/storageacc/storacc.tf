resource "azurerm_resource_group" "example" {
  name     = var.rgname
  location = var.location
}
resource "azurerm_storage_account" "examplestorage" {
  name                     = var.stname
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
resource "azurerm_storage_container" "Blob" {
  name                  = var.blobname
  storage_account_name  = azurerm_storage_account.examplestorage.name
  container_access_type = "private"
}

resource "azurerm_storage_queue" "Queue" {
  name                 = var.queuename
  storage_account_name = azurerm_storage_account.examplestorage.name
}