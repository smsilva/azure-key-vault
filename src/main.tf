data "azurerm_client_config" "current" {}

locals {
  terraform_service_principal_object_id = [data.azurerm_client_config.current.object_id]
  administrator_objects_list            = concat(local.terraform_service_principal_object_id, var.administrators)
}

resource "random_string" "key_vault_id" {
  keepers = {
    name     = var.name
    location = var.resource_group.location
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
