resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}"
  location = "${var.location}"
}
resource "azurerm_public_ip" "puip" {
  name                = "${var.prefix}-puip"
  resource_group_name =  azurerm_resource_group.rg.name
  location            =  azurerm_resource_group.rg.location
  allocation_method   =  "Static"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            =  azurerm_resource_group.rg.location
  resource_group_name =  azurerm_resource_group.rg.name
  address_space       = ["${var.vnet_prefix}"]
}

resource "azurerm_subnet" "snet"{
  name                 = "${var.prefix}-snet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["${var.snet_prefix}"]
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
     name                          = "internal"
     subnet_id                     = azurerm_subnet.snet.id
     private_ip_address_allocation = "Dynamic"
     public_ip_address_id          = azurerm_public_ip.puip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "var.prefix-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
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
     name                       = "SSH"
     priority                   = 101
     direction                  = "Inbound"
     access                     = "Allow"
     protocol                   = "Tcp"
     source_port_range          = "*"
     destination_port_range     = "22"
     source_address_prefix      = "*"
     destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "nsga" {
   subnet_id                 = azurerm_subnet.snet.id
   network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "lvm" {
   name                = "${var.prefix}-machine"
   resource_group_name = azurerm_resource_group.rg.name
   location            = azurerm_resource_group.rg.location
   size                = "Standard_D2ads_v5"
   admin_username      = "${var.username}"
   admin_password      = "${var.password}"
   network_interface_ids = [
     azurerm_network_interface.nic.id,
   ]     
  
  os_disk {
     caching              = "ReadWrite"
     storage_account_type = "Standard_LRS"
  }
  admin_ssh_key {
     username   = "${var.username}"
     public_key = tls_private_key.ssh.public_key_openssh
   }
 source_image_reference {
       publisher = "Canonical"
       offer     = "UbuntuServer"
       sku       = "18.04-LTS"
       version   = "latest"
    }
}