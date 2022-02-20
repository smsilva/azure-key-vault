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
  key_vault_name = "silvios-test-04-${random_string.instance_id.result}"
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

module "secrets" {
  source = "../../src/secrets"

  vault = module.vault.instance
  values = {
    "service-principal-object-id" = data.azurerm_client_config.current.object_id
    "service-principal-tenant-id" = data.azurerm_client_config.current.tenant_id
  }

  depends_on = [
    module.vault
  ]
}

output "instances" {
  value     = module.secrets.instances
  sensitive = true
}

output "service_principal_object_id" {
  value = nonsensitive(module.secrets.instances["service-principal-object-id"].id)
}

output "service_principal_tenant_id" {
  value = nonsensitive(module.secrets.instances["service-principal-tenant-id"].id)
}
