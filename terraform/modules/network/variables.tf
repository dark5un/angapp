variable "environment" {
  description = "The environment name"
  type = string
}

variable "app_port" {
  default = 80
}

variable "az_count" {
  default = 2
}
