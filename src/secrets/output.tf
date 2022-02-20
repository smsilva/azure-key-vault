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

output "instances" {
  value     = local.secrets_map
  sensitive = true
}
