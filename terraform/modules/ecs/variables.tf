variable "environment" {
  description = "The environment name"
  type = string
}

variable "app_port" {
  default = 80
}

variable "fargate_memory" {
  default = 2048
}

variable "fargate_cpu" {
  default = 1024
}

variable "app_image" {
  default = "936166041009.dkr.ecr.eu-west-1.amazonaws.com/angapp_angapp:latest"
}

variable "proxy_image" {
  default = "936166041009.dkr.ecr.eu-west-1.amazonaws.com/angapp_nginx:latest"
}

variable "front_end_listener" {}
variable "alb_target_group" {}
variable "vpc_id" {}
variable "ecs_tasks_security_group_id" {}

variable "app_count" {
  default = 1
}
