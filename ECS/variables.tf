variable "vpc_zone_identifier" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "key_name" {
  type = string
}

# variable "priority" {
#   type        = number
#   description = "The priority count for creating resources"
#   default     = 5 # default value, optional
# }

variable "host_header" {
  type = list(string)
}

variable "path_pattern" {
  type = list(string)
}

variable "listener_arn" {
  type = string
}

variable "load_balancer_arn" {
  type = string
}

variable "ecs_cluster" {
  type = string
}

variable "ecs_task_definition" {
  type = string
}

variable "network_mode" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "image" {
  type = string
}

variable "asg" {
  type = string
}

variable "target_group" {
  type = string
}

variable "cw_logs" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "ssl_policy" {
  type = string
}

variable "desired_count" {
  type = string
}

variable "retention_in_days" {
  type = number
}

variable "memoryReservation" {
  type = number
}

variable "containerPort" {
  type = number
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "max_size" {
  type = number
}

variable "priority" {
  type = number
}
