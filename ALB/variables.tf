variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "load_balancer_type" {
  type = string
}

variable "region" {
  type = string
}

variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}

variable "security_group_alb" {
  type = string
}

variable "description" {
  type = string
}

variable "alb_sg_name" {
  type = string
}

variable "alb_name" {
  type = string
}