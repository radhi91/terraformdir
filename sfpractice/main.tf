resource "azurerm_resource_group" "terrarg"{
  name     = var.resoname
  location = var.location
}
terraform {
  backend "azurerm" {
    resource_group_name  = "storage"
    storage_account_name = "radsto"
    container_name       = "mycont"
    key                  = "prod.terraform.tfstate"
  }
}
resource "azurerm_public_ip" "terrargpuip" {
  name                = "terrarg-puip"
  resource_group_name = azurerm_resource_group.terrarg.name
  location            = azurerm_resource_group.terrarg.location
  allocation_method   = "Static"
}
resource "azurerm_virtual_network" "terrargvnet" {
  name                = "terrarg-vent"
  location            = azurerm_resource_group.terrarg.location
  resource_group_name = azurerm_resource_group.terrarg.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "terratgsnet" {
  name                 = "terrarg-snet"
  resource_group_name  = azurerm_resource_group.terrarg.name
  virtual_network_name = azurerm_virtual_network.terrargvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "terrargnic" {          
  name                = "terrarg-nic"
  location            = azurerm_resource_group.terrarg.location
  resource_group_name = azurerm_resource_group.terrarg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terratgsnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terrargpuip.id
  }
}
resource "azurerm_network_security_group" "terrargnsg" {
  name                = "terrarg-nsg"
  location            = azurerm_resource_group.terrarg.location
  resource_group_name = azurerm_resource_group.terrarg.name

  security_rule {
    name                       = "TCP-IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "RDP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "terratgsnetas" {
  subnet_id                 = azurerm_subnet.terratgsnet.id
  network_security_group_id = azurerm_network_security_group.terrargnsg.id
}
resource "azurerm_windows_virtual_machine" "terrargvm" {
  name                  = "${var.vmname}"
  resource_group_name   = azurerm_resource_group.terrarg.name
  location              = azurerm_resource_group.terrarg.location
  size                  = "Standard_B1s"
  admin_username        = var.username
  admin_password        = var.password
  network_interface_ids = [
     azurerm_network_interface.terrargnic.id,
   ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-Datacenter"
    version   = "latest"
  }
}