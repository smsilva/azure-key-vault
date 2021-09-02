data "azurerm_client_config" "current" {}

locals {
  terraform_service_principal_object_id = [data.azurerm_client_config.current.object_id]
  administrator_objects_list            = concat(local.terraform_service_principal_object_id, var.administrators)
}

resource "random_string" "key_vault_id" {
  keepers = {
    name                   = var.name
    platform_instance_name = var.platform_instance_name
    location               = var.resource_group.location
  }

  length      = 3
  min_numeric = 1
  min_lower   = 1
  special     = false
  upper       = false
}

resource "azurerm_key_vault" "default" {
  name                       = "${var.name}-${random_string.key_vault_id.result}"
  location                   = var.resource_group.location
  resource_group_name        = var.resource_group.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = false # Should we change this to not allow a key vault be purged before retention period
}

resource "azurerm_key_vault_access_policy" "administrator" {
  for_each = toset(local.administrator_objects_list)

  key_vault_id = azurerm_key_vault.default.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update",
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]
}
