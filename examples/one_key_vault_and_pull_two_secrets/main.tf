provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "random_string" "instance_id" {
  length      = 6
  min_lower   = 1
  min_numeric = 2
  lower       = true
  special     = false
}

locals {
  key_vault_name = "wasp-test-02-${random_string.instance_id.result}"
  location       = "eastus2"
  administrators = [
    data.azurerm_client_config.current.object_id,
    "805a3d92-4178-4ad1-a0d6-70eae41a463a"
  ]
}

resource "azurerm_resource_group" "default" {
  name     = local.key_vault_name
  location = local.location
}

module "vault" {
  source = "../../src"

  name           = local.key_vault_name
  resource_group = azurerm_resource_group.default
  administrators = local.administrators
}

module "vault_push" {
  source = "../../src/push"

  vault_id = module.vault.id
  secrets = [
    { id = "key1", value = "super_secret_1" },
    { id = "key2", value = "super_secret_2" },
    { id = "key3", value = "super_secret_3" },
  ]

  depends_on = [
    module.vault
  ]
}

output "secrets_id_list" {
  value = module.vault_push.secrets_id_list
}
