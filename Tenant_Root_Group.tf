
resource "azurerm_resource_group" "vansh_networkwatcher" {
  name = "Rg-networkwatcher"
  location = "central india"
}

resource "azurerm_resource_group" "vansh_Rg" {
  name = "vansh_Rgr"
  location = "central india"
}

resource "azurerm_virtual_network" "Vnet" {
  name = "Vansh_Vnet"
  location = azurerm_resource_group.vansh_networkwatcher.location
  resource_group_name = azurerm_resource_group.vansh_networkwatcher.name
  address_space = [ "192.168.0.0/16" ]
  dns_servers = [ "192.168.0.1","192.168.0.11" ]
}

resource "azurerm_subnet" "Vsubnet" {
  name                 = "Vansh-subnet"
  resource_group_name  = azurerm_resource_group.vansh_networkwatcher.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_subnet" "Vsubnet2" {
  name                 = "Vansh-subnet2"
  resource_group_name  = azurerm_resource_group.vansh_networkwatcher.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["192.168.2.0/24"]
}

resource "azurerm_network_security_group" "Vnsg" {
  name                = "Vnsg1"
  location            = azurerm_resource_group.vansh_networkwatcher.location
  resource_group_name = azurerm_resource_group.vansh_networkwatcher.name

  security_rule {
    name                       = "Rule_ssh"
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
    name                       = "Rule_rdp"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Rule_http"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Rule_https"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_watcher" "Vwatcher" {
  name                = "vansh-networkwatcher"
  location            = azurerm_resource_group.vansh_networkwatcher.location
  resource_group_name = azurerm_resource_group.vansh_networkwatcher.name
}

resource "azurerm_network_interface" "vint" {
  name = "vanshint"
  location = azurerm_resource_group.vansh_networkwatcher.location
  resource_group_name = azurerm_resource_group.vansh_networkwatcher.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Vsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Vansh_pip.id
  }
}

resource "azurerm_windows_virtual_machine" "vansh_vm" {
  name = "vanshVM"
  location = azurerm_resource_group.vansh_Rg.location
  resource_group_name = azurerm_resource_group.vansh_Rg.name
  admin_username = "vansh"
  admin_password = "Vansh@7522"
  size = "Standard_DS1_v2"
  network_interface_ids = [
    azurerm_network_interface.vint.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
resource "azurerm_public_ip" "Vansh_pip" {
  name                = "Vansh_pip1"
  resource_group_name = azurerm_resource_group.vansh_Rg.name
  location            = azurerm_resource_group.vansh_Rg.location
  allocation_method   = "Static"
  }

resource "azurerm_storage_account" "vansh_terraform" {
  name = "vanshstorage123456"
  resource_group_name      = azurerm_resource_group.vansh_Rg.name
  location                 = azurerm_resource_group.vansh_Rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Creator = "Vansh"
  }
}

resource "azurerm_storage_container" "vcontainer" {
  name                  = "vcont"
  storage_account_name  = azurerm_storage_account.vansh_terraform.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "vanshblob" {
  name                   = "file.txt"
  storage_account_name   = azurerm_storage_account.vansh_terraform.name
  storage_container_name = azurerm_storage_container.vcontainer.name
  type                   = "Block"
  source                 = "D:/Azure_Terraform/file.txt"
}
