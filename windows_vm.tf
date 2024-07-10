

resource "azurerm_resource_group" "vtest" {
  name = "Vansh_Terra"
  location = "central india"
}



resource "azurerm_virtual_network" "vnet123" {
  name="Vansh_Terra_net"
  location = azurerm_resource_group.vtest.location
  resource_group_name = azurerm_resource_group.vtest.name
  address_space = [ "10.0.0.0/16" ]
  dns_servers = [ "10.0.0.4","10.0.0.5" ] 
tags = {
  "creator" = "vansh Harode" 
  
}
}
resource "azurerm_subnet" "vansh_default" {
  name                 = "vansh_default_subnet"
  resource_group_name  = azurerm_resource_group.vtest.name
  virtual_network_name = azurerm_virtual_network.vnet123.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_network_interface" "vint" {
  name = "vanshint"
  location = azurerm_resource_group.vtest.location
  resource_group_name = azurerm_resource_group.vtest.name
   ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vansh_default.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_windows_virtual_machine" "vansh_vm" {
  name = "vanshVM"
  location = azurerm_resource_group.vtest.location
  resource_group_name = azurerm_resource_group.vtest.name
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
