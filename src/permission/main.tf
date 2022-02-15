data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "default" {
  key_vault_id            = var.vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = var.object_id
  certificate_permissions = var.certificate_permissions
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
}
