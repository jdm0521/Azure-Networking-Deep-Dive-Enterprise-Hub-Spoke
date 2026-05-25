variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "hub_vnet_address_space" {
  type = list(string)
}

variable "hub_subnet_name" {
  type = string
}

variable "hub_subnet_address_prefixes" {
  type = list(string)
}
variable "spoke1_vnet_name" {
  type = string
}

variable "spoke1_address_space" {
  type = list(string)
}

variable "spoke1_subnet_name" {
  type = string
}

variable "spoke1_subnet_prefixes" {
  type = list(string)
}

variable "spoke2_vnet_name" {
  type = string
}

variable "spoke2_address_space" {
  type = list(string)
}

variable "spoke2_subnet_name" {
  type = string
}

variable "spoke2_subnet_prefixes" {
  type = list(string)
}