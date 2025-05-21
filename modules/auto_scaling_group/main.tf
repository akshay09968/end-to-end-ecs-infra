resource "aws_autoscaling_group" "ecs" {
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.vpc_zone_identifier
  target_group_arns   = var.target_group_arns

  # ECS cluster integration tag
  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }

  # Name tag
  tag {
    key                 = "Name"
    value               = var.name_tag
    propagate_at_launch = true
  }

  # Additional tags from the input variable
  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}
