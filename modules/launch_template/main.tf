variable "name" {
  default = ""
}

resource "aws_launch_template" "ecs" {
  name = var.name

  iam_instance_profile {
    name = "zaggle-prod-ecsrole"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp3"
    }
  }

  network_interfaces {
    security_groups             = var.security_groups
    associate_public_ip_address = true
  }

  instance_type = var.instance_type
  key_name      = var.key_name
  image_id      = data.aws_ami.ecs_optimized.id

  user_data = var.user_data

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}


data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

output "launch_template_id" {
  value       = aws_launch_template.ecs.id
  description = "The ID of the launch template"
}

