variable "vault" {
  type = object({
    id = string
  })
}

variable "values" {
  description = "A List of Objects that are a key and a secret for it"
  type        = map(string)
}
