data "azurerm_client_config" "current" {}

variable "name" {
  type        = string
  description = "Azure Key Vault Base Name"
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Azure Key Vault Resource Group"
}

variable "administrators" {
  type        = list(string)
  description = "Azure Active Directory Object ID List. The Objects (Users, Groups, Service Principals, etc) listed here will have Administrator Privileges against the Key Vault Instance"
  default     = []
}

variable "sku_name" {
  type        = string
  description = "Azure Key Vault sku_name"
  default     = "standard"
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days that items should be retained for once soft-deleted. This value can be between 7 (default) and 90 days"
  default     = 7
}

variable "tags" {
  default = {}
}
