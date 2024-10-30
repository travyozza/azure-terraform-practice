terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "atp-rg" {
  name     = "${var.prefix}rg"
  location = var.location
}

resource "azurerm_virtual_network" "atp-vn" {
  name                = "${var.prefix}network"
  resource_group_name = azurerm_resource_group.atp-rg.name
  location            = var.location
  address_space       = ["10.123.0.0/16"]
  depends_on          = [azurerm_resource_group.atp-rg]

}

resource "azurerm_subnet" "atp-subnet" {
  name                 = "${var.prefix}vm-subnet"
  resource_group_name  = azurerm_resource_group.atp-rg.name
  virtual_network_name = azurerm_virtual_network.atp-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "atp-sg" {
  name                = "${var.prefix}sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.atp-rg.name
}

resource "azurerm_network_security_rule" "atp-ns-rule" {
  name                        = "${var.prefix}ns-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.atp-rg.name
  network_security_group_name = azurerm_network_security_group.atp-sg.name
}

resource "azurerm_subnet_network_security_group_association" "atp-sga" {
  subnet_id                 = azurerm_subnet.atp-subnet.id
  network_security_group_id = azurerm_network_security_group.atp-sg.id
}

resource "azurerm_public_ip" "atp-ip" {
  name                = "${var.prefix}ip"
  resource_group_name = azurerm_resource_group.atp-rg.name
  location            = var.location
  allocation_method   = "Static"
}