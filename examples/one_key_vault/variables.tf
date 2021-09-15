provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

variable "company_name" {
  type    = string
  default = "silvios"
}

variable "platform_instance_name" {
  type    = string
  default = "wasp-sbx-iq1"
}
