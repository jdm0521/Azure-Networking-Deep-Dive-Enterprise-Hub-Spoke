resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "storage-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name

  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "this" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = var.subnet_id

  private_service_connection {
    name                           = "storage-connection"
    private_connection_resource_id = var.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
  }
}
resource "azurerm_private_dns_zone_virtual_network_link" "spoke1" {
  name                  = "spoke1-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name

  virtual_network_id = var.spoke1_vnet_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke2" {
  name                  = "spoke2-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name

  virtual_network_id = var.spoke2_vnet_id
}