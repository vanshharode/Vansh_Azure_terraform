

resource "azurerm_resource_group" "vansh_terraform" {
    name="vansh_terra"
    location = "central india"
  
}

resource "azurerm_virtual_network" "Vnet" {
  name = "Vansh_network"
  location=azurerm_resource_group.vansh_terraform.location
  resource_group_name = azurerm_resource_group.vansh_terraform.name
  address_space = [ "12.0.0.0/16" ]
  dns_servers         = ["12.0.0.4", "12.0.0.5"]
 subnet {
    name           = "default_subnet1"
    address_prefix = "12.0.1.0/24"
 }
  tags = {
    "creator" =  "Vasnsh Harode "
  }
}

