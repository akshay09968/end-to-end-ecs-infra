variable "name" {
  description = "The name of the ECS service"
  type        = string
}

variable "cluster_id" {
  description = "The ECS cluster ID where the service will run"
  type        = string
}

variable "task_definition" {
  description = "The task definition ARN to run with the ECS service"
  type        = string
}

variable "desired_count" {
  description = "The desired number of instances of the task"
  type        = number
  default     = 1
}

variable "target_group_arn" {
  description = "The ARN of the target group to associate with the ECS service"
  type        = string
}

variable "container_name" {
  description = "The name of the container for the ECS task"
  type        = string
}

variable "container_port" {
  description = "The port on the container to use for the load balancer"
  type        = number
}

variable "environment" {
  description = "Environment for tagging (e.g., dev, staging, prod)"
  type        = string
}