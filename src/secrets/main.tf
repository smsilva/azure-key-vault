module "secret" {
  for_each = var.values

  source = "../secret"

  vault = var.vault
  key   = each.key
  value = each.value
}

locals {
  secrets = flatten([
    for key in keys(module.secret) : [
      {
        key      = key,
        instance = module.secret[key].instance
      }
    ]
  ])

  secrets_map = {
    for secret in local.secrets : secret.key => secret.instance
  }
}
