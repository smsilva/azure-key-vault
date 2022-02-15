output "instance" {
  value     = azurerm_key_vault_secret.default
  sensitive = true
}
