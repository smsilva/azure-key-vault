variable "vault" {
  type = object({
    id = string
  })
}

variable "key" {
  type = string
}

variable "value" {
  type      = string
  sensitive = true
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags."
  default     = {}
}
