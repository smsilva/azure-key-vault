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
  key_vault_name = "wasp-test-04-${random_string.instance_id.result}"
  location       = "eastus2"
  administrators = [
    "805a3d92-4178-4ad1-a0d6-70eae41a463a"
  ]

  service_principal_object_id = replace(data.azurerm_client_config.current.object_id, "-", "")

  tags = {
    ResponsibleTeam = "Compute & Integration"
    Repository      = "azure-key-vault"
    Creator         = local.service_principal_object_id
  }
}

resource "azurerm_resource_group" "default" {
  name     = local.key_vault_name
  location = local.location
  tags     = local.tags
}

module "vault" {
  source = "../../src"

  name           = local.key_vault_name
  resource_group = azurerm_resource_group.default
  administrators = local.administrators
  tags           = local.tags
}

module "secret_service_principal_object_id" {
  source = "../../src/secret"

  vault = module.vault.instance
  key   = "service-principal-object-id"
  value = data.azurerm_client_config.current.object_id

  depends_on = [
    module.vault
  ]
}

module "permission_user" {
  source = "../../src/permission"

  vault     = module.vault.instance
  object_id = "db005870-2bd8-4224-b01d-c6a4229ac209" # user
  secret_permissions = [
    "List"
  ]

  depends_on = [
    module.vault
  ]
}

output "key_vault_id" {
  value = module.vault.instance.id
}
