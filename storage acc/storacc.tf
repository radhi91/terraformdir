resource "azurerm_resource_group" "example" {
  name     = "myrg"
  location = "East US"
}
resource "azurerm_storage_account" "examplestorage" {
  name                     = "frststorage"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
resource "azurerm_storage_container" "Blob" {
  name                  = "blobcontainer"
  storage_account_name  = azurerm_storage_account.examplestorage.name
  container_access_type = "private"
}

resource "azurerm_storage_queue" "Queue" {
  name                 = "queuetype"
  storage_account_name = azurerm_storage_account.examplestorage.name
}