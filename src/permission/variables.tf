variable "vault" {
  type = object({
    id = string
  })
}

variable "object_id" {
  type = string  
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags."
  default     = {}
}

variable "certificate_permissions" {
  default = []
}

variable "key_permissions" {
  default = []
}

variable "secret_permissions" {
  default = []
}
