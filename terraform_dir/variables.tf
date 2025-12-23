variable "keyvault-name" {
  type = string
}

variable "db-name" {
  type = string
}


variable "db-username" {
  type = string
}

variable "db-password" {
  type = string
  sensitive = true
}

variable "backend-ingress-port" {
  type = number
}