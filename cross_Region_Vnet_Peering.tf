provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "vansh_virtual_net" {
  name     = "vansh_vnet"
  location = "central india"
}

resource "azurerm_resource_group" "vansh_virtual_net2" {
  name     = "vansh_vnet2"
  location = "east us"
}
//************************ Resources for First Virtual_network in Central India  region **************************//
resource "azurerm_virtual_network" "vnet1" {
  name                = "vpc1"
  location            = azurerm_resource_group.vansh_virtual_net.location
  resource_group_name = azurerm_resource_group.vansh_virtual_net.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.11"]
  tags = {
    "creator" = "Vansh Harode "
  }
}

resource "azurerm_subnet" "vnet_subnet1" {
  name                 = "vpc1_subnet"
  resource_group_name  = azurerm_resource_group.vansh_virtual_net.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vpc1_pip" {
  name                = "public1"
  location            = azurerm_resource_group.vansh_virtual_net.location
  resource_group_name = azurerm_resource_group.vansh_virtual_net.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vint1" {
  name                = "vpc1-nic"
  location            = azurerm_resource_group.vansh_virtual_net.location
  resource_group_name = azurerm_resource_group.vansh_virtual_net.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vpc1_pip.id
  }
}
resource "azurerm_network_security_group" "vnet_nsg1" {
  name                = "nsg1"
  location            = azurerm_resource_group.vansh_virtual_net.location
  resource_group_name = azurerm_resource_group.vansh_virtual_net.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "Vm1" {
  name                            = "Vanshvm1"
  resource_group_name             = azurerm_resource_group.vansh_virtual_net.name
  location                        = azurerm_resource_group.vansh_virtual_net.location
  size                            = "Standard_F2"
  admin_username                  = "Vansh1"
  admin_password                  = "Vansh@7522"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vint1.id
  ]




  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}




//************************ Resources for Second Virtual_network in East US  region **************************//

resource "azurerm_virtual_network" "vnet2" {
  name                = "vpc2"
  location            = azurerm_resource_group.vansh_virtual_net2.location
  resource_group_name = azurerm_resource_group.vansh_virtual_net2.name
  address_space       = ["192.168.0.0/20"]
  dns_servers         = ["192.168.0.4", "192.168.0.11"]
  tags = {
    "creator" = "Vansh Harode "
  }
}

resource "azurerm_subnet" "vnet_subnet2" {
  name                 = "vpc1_subnet"
  resource_group_name  = azurerm_resource_group.vansh_virtual_net2.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_public_ip" "vpc2_pip" {
  name                = "public1"
  location            = azurerm_resource_group.vansh_virtual_net2.location
  resource_group_name = azurerm_resource_group.vansh_virtual_net2.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vint2" {
  name                = "vpc1-nic"
  location            = azurerm_resource_group.vansh_virtual_net2.location
  resource_group_name = azurerm_resource_group.vansh_virtual_net2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet_subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vpc2_pip.id
  }
}
resource "azurerm_network_security_group" "vnet_nsg2" {
  name                = "nsg1"
  location            = azurerm_resource_group.vansh_virtual_net2.location
  resource_group_name = azurerm_resource_group.vansh_virtual_net2.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "Vm2" {
  name                            = "Vanshvm2"
  resource_group_name             = azurerm_resource_group.vansh_virtual_net2.name
  location                        = azurerm_resource_group.vansh_virtual_net2.location
  size                            = "Standard_F2"
  admin_username                  = "Vansh2"
  admin_password                  = "Vansh@9934"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vint2.id
  ]




  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


// ************************** Code for Vnet Peering ******************************* //

resource "azurerm_virtual_network_peering" "vnetp1" {
  name                      = "vnetpeer1to2"
  resource_group_name       = azurerm_resource_group.vansh_virtual_net.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

resource "azurerm_virtual_network_peering" "vnetp2" {
  name                      = "vnetpeer2to1"
  resource_group_name       = azurerm_resource_group.vansh_virtual_net2.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}