resource "azurerm_resource_group" "rg1" {
  name     = "${var.rgname}"
  location = "${var.location}"
}
terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "abcd1234"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  address_space       = ["${var.vnet_prefix}"]
}

resource "azurerm_subnet" "snet1" {
  name                 = "${var.prefix}-snet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["${var.snet_prefix}"]
}

resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                = "${var.prefix}-vmss"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  sku                 = "Standard_F2"
  instances           = 2
  admin_password      = "${var.password}"
  admin_username      = "${var.username}"

  source_image_reference {
     publisher = "MicrosoftWindowsServer"
     offer     = "WindowsServer"
     sku       = "2016-Datacenter-Server-Core"
     version   = "latest"
  }

  os_disk {
     storage_account_type = "Standard_LRS"
     caching              = "ReadWrite"
  }

  network_interface {
     name    = "nic"
     primary = true

    ip_configuration {
      name      = "nic-ip"
      primary   = true
      subnet_id = azurerm_subnet.snet1.id
    }
  }
}