variable "key_vault_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "secrets" {
  type      = map(string)
  sensitive = true
}