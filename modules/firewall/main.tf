resource "azurerm_public_ip" "this" {
  name                = "${var.firewall_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_firewall" "this" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}

resource "azurerm_firewall_network_rule_collection" "internal" {
  name                = "allow-internal"
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name

  priority = 100
  action   = "Allow"

  rule {
    name = "allow-spoke-traffic"

    protocols = [
      "TCP",
      "UDP"
    ]

    source_addresses = [
      "10.1.0.0/16",
      "10.2.0.0/16"
    ]

    destination_addresses = [
      "10.1.0.0/16",
      "10.2.0.0/16"
    ]

    destination_ports = [
      "22"
    ]
  }
}