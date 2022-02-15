resource "azurerm_key_vault_secret" "default" {
  key_vault_id = var.vault.id
  name         = var.key
  value        = var.value
  tags         = var.tags
}
