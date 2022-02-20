output "instances" {
  value     = local.secrets_map
  sensitive = true
}
