




resource "azurerm_resource_group" "vstorage" {
  name="vansh_storage7522"
  location = "central india"
  
  
}

resource "azurerm_storage_account" "vansh_terraform" {
  name = "vanshstorage123456"
  resource_group_name      = azurerm_resource_group.vstorage.name
  location                 = azurerm_resource_group.vstorage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
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
  source                 = "D:/azure/file.txt"
}