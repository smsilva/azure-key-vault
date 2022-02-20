module "secret" {
  for_each = var.values

  source = "../secret"

  vault = var.vault
  key   = each.key
  value = each.value
}
