provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "platform_instance" {
  name = var.platform_instance_name
}

variable "company_name" {
  type    = string
  default = "silvios"
}

variable "platform_instance_name" {
  type    = string
  default = "wasp-sbx-iq1"
}
