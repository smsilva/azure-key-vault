locals {
  platform_instance_region = "centralus"
  administrators           = ["805a3d92-4178-4ad1-a0d6-70eae41a463a"]
}

module "vault" {
  source = "../../src"

  name           = "${var.company_name}-${var.platform_instance_name}"
  resource_group = data.azurerm_resource_group.platform_instance
  administrators = local.administrators
}
