# --- Variables ---
variable "launch_template_id" {
  description = "ID of the launch template"
  type        = string
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
}

variable "vpc_zone_identifier" {
  description = "List of subnet IDs to launch resources in"
  type        = list(string)
}

variable "name_tag" {
  description = "Value of the Name tag for the ASG"
  type        = string
}

variable "target_group_arns" {
  description = "List of target group ARNs to associate with the ASG"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the Auto Scaling Group"
  type        = list(object({
    key                 = string
    value               = string
    propagate_at_launch = bool
  }))
  default = []
}
