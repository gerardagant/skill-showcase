variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "secrets" {
  type      = map(string)
  sensitive = true
}
