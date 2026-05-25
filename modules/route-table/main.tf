resource "azurerm_route_table" "this" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "this" {
  name                   = "route-to-firewall"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.this.name

  address_prefix         = var.address_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.this.id
}