# Creation of Virtual Network, and subnet. 3 virtual networks and 3 subnets. 
resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.hub_vnet_address_space
}

resource "azurerm_subnet" "hub_subnet" {
  name                 = var.hub_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.hub_subnet_address_prefixes
}

resource "azurerm_virtual_network" "spoke1_vnet" {
  name                = var.spoke1_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.spoke1_address_space
}

resource "azurerm_subnet" "spoke1_subnet" {
  name                 = var.spoke1_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
  address_prefixes     = var.spoke1_subnet_prefixes
}

resource "azurerm_virtual_network" "spoke2_vnet" {
  name                = var.spoke2_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.spoke2_address_space
}

resource "azurerm_subnet" "spoke2_subnet" {
  name                 = var.spoke2_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
  address_prefixes     = var.spoke2_subnet_prefixes
}

#Virtual network peering 
resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                      = "hub-to-spoke1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1_vnet.id
}

resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                      = "spoke1-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke1_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
}

resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
  name                      = "hub-to-spoke2"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2_vnet.id
}

resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                      = "spoke2-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke2_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
}
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#Azure Firewall
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.10.0/24"]
}