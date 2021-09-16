variable "vault_id" {
  type        = string
  description = "Azure Key Vault ID"
}

variable "secrets" {
  type = list(object({
    id    = string
    value = string
  }))
  description = "A List of Objects that are a key and a secret for it"
}

locals {
  secrets_map = {
    for secret in var.secrets : secret.id => {
      secret = secret.value
    }
  }
}

resource "azurerm_key_vault_secret" "list" {
  for_each = local.secrets_map

  key_vault_id = var.vault_id
  name         = each.key
  value        = each.value.secret
}

output "secrets_id_list" {
  value = tomap({
    for key, secret in azurerm_key_vault_secret.list : key => secret.id
  })
}
