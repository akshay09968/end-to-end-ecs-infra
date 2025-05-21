variable "instance_type" {
  description = "The instance type for ECS instances"
  type        = string
}

variable "security_groups" {
  description = "A list of security group IDs for the ECS instances"
  type        = list(string)
}

variable "key_name" {
  description = "The EC2 key pair name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The ECS cluster name"
  type        = string
}

variable "bucket" {
  type = string
}

variable "dynamodb_table" {
  type = string
}

variable "key" {
  type = string
}

variable "user_data" {
  type        = string
  description = "Base64-encoded user data for the instance"
  default     = "" # Default to empty if not provided
}

variable "tags" {
  description = "Tags to apply to resources in the launch template"
  type        = map(string)
  default     = {}
}
