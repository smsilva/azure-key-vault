locals {
  platform_instance_region = "centralus"
  administrators = [
    data.azurerm_client_config.current.object_id,
    "805a3d92-4178-4ad1-a0d6-70eae41a463a"
  ]
}

resource "azurerm_resource_group" "platform_instance" {
  name     = var.platform_instance_name
  location = local.platform_instance_region
}

module "vault" {
  source = "../../src"

  name           = "${var.company_name}-${var.platform_instance_name}"
  resource_group = azurerm_resource_group.platform_instance
  administrators = local.administrators
}

module "vault_push" {
  source = "../../src/push"

  vault_id = module.vault.id
  secrets = [
    { id = "key1", value = "super_secret_1" },
    { id = "key2", value = "super_secret_2" },
    { id = "key3", value = "super_secret_3" },
  ]

  depends_on = [
    module.vault
  ]
}

output "secrets_id_list" {
  value = module.vault_push.secrets_id_list
}
