output "hub_vnet_id" {
  value = azurerm_virtual_network.hub_vnet.id
}

output "hub_subnet_id" {
  value = azurerm_subnet.hub_subnet.id
}

output "spoke1_subnet_id" {
  value = azurerm_subnet.spoke1_subnet.id
}

output "spoke2_subnet_id" {
  value = azurerm_subnet.spoke2_subnet.id
}
output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}
output "firewall_subnet_id" {
  value = azurerm_subnet.firewall_subnet.id
}
output "spoke1_vnet_id" {
  value = azurerm_virtual_network.spoke1_vnet.id
}

output "spoke2_vnet_id" {
  value = azurerm_virtual_network.spoke2_vnet.id
}