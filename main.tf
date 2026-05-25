resource "azurerm_resource_group" "networking_lab" {
  name     = var.resource_group_name
  location = var.location
}

module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  hub_vnet_name          = "vnet-hub"
  hub_vnet_address_space = ["10.0.0.0/16"]

  hub_subnet_name             = "snet-shared"
  hub_subnet_address_prefixes = ["10.0.1.0/24"]

  spoke1_vnet_name       = "vnet-spoke1"
  spoke1_address_space   = ["10.1.0.0/16"]
  spoke1_subnet_name     = "snet-app"
  spoke1_subnet_prefixes = ["10.1.1.0/24"]

  spoke2_vnet_name       = "vnet-spoke2"
  spoke2_address_space   = ["10.2.0.0/16"]
  spoke2_subnet_name     = "snet-data"
  spoke2_subnet_prefixes = ["10.2.1.0/24"]
}


module "spoke1_nsg" {
  source = "./modules/nsg"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  nsg_name = "nsg-spoke1-app"

  subnet_id = module.networking.spoke1_subnet_id
}

module "spoke2_nsg" {
  source = "./modules/nsg"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  nsg_name = "nsg-spoke2-data"

  subnet_id = module.networking.spoke2_subnet_id
}
module "vm_app" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  vm_name   = "vm-app"
  subnet_id = module.networking.spoke1_subnet_id

  admin_username = var.admin_username
  admin_password = var.admin_password
}

module "vm_data" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  vm_name   = "vm-data"
  subnet_id = module.networking.spoke2_subnet_id

  admin_username = var.admin_username
  admin_password = var.admin_password
}

module "bastion" {
  source = "./modules/bastion"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  bastion_name = "bas-hub"

  subnet_id = module.networking.bastion_subnet_id
}

module "firewall" {
  source = "./modules/firewall"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  firewall_name = "fw-hub"

  subnet_id = module.networking.firewall_subnet_id
}

module "spoke1_route_table" {
  source = "./modules/route-table"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  route_table_name = "rt-spoke1"

  subnet_id = module.networking.spoke1_subnet_id

  firewall_private_ip = module.firewall.firewall_private_ip

  address_prefix = "10.2.0.0/16"
}

module "spoke2_route_table" {
  source = "./modules/route-table"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  route_table_name = "rt-spoke2"

  subnet_id = module.networking.spoke2_subnet_id

  firewall_private_ip = module.firewall.firewall_private_ip

  address_prefix = "10.1.0.0/16"
}
module "storage" {
  source = "./modules/storage"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  storage_account_name = "stnetworklabjdm52112345"
}
module "private_endpoint" {
  source = "./modules/private-endpoint"

  resource_group_name = azurerm_resource_group.networking_lab.name
  location            = azurerm_resource_group.networking_lab.location

  private_endpoint_name = "pe-storage"

  subnet_id = module.networking.spoke2_subnet_id

  storage_account_id = module.storage.storage_account_id

  vnet_id        = module.networking.hub_vnet_id
  spoke1_vnet_id = module.networking.spoke1_vnet_id
  spoke2_vnet_id = module.networking.spoke2_vnet_id
}