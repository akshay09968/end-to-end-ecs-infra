# --- Local Variables ---
locals {
  instance_types = {
    "dev"     = "t3.nano"
    "staging" = "t3.small"
    "prod"    = "t3.micro"
  }

  aws_region    = "ap-south-2"
  instance_type = lookup(local.instance_types, terraform.workspace, "t3.micro")
}

# --- ECS Cluster ---
resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster
}

# --- ECS Task Definition for Frontend ---
resource "aws_ecs_task_definition" "frontend" {
  family                   = var.ecs_task_definition
  network_mode             = var.network_mode
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name              = var.ecs_task_definition
      image             = var.image
      essential         = true
      memoryReservation = var.memoryReservation
      portMappings = [
        {
          containerPort = var.containerPort
          hostPort      = 0

        }
      ]
      environment = [
        {
          name  = "ENVIRONMENT"
          value = terraform.workspace
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = local.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = var.ecs_task_definition
  }

  lifecycle {
    ignore_changes = [container_definitions]
  }

  depends_on = [aws_cloudwatch_log_group.ecs_logs]
}

# --- CloudWatch Log Group ---
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = var.cw_logs
  retention_in_days = var.retention_in_days
  tags = {
    Environment = terraform.workspace
  }
}

# --- ECS Service Module with Load Balancer Integration ---
module "ecs_service_frontend" {
  source           = "../modules/ecs_service"
  name             = var.ecs_task_definition
  cluster_id       = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.frontend.arn
  desired_count    = 1
  target_group_arn = aws_lb_target_group.example.arn
  container_name   = var.ecs_task_definition
  container_port   = var.containerPort
  environment      = terraform.workspace

  depends_on = [
    aws_cloudwatch_log_group.ecs_logs,
    aws_ecs_cluster.main,
    aws_lb_listener.https_listener
  ]
}


# --- Launch Template Module ---
module "launch_template" {
  source           = "../modules/launch_template"
  name             = "zaggle-${terraform.workspace}-be-LT"
  instance_type    = local.instance_type
  security_groups  = [aws_security_group.ecs_service.id, aws_security_group.ssh.id]
  key_name         = var.key_name
  ecs_cluster_name = aws_ecs_cluster.main.name

  # Add user data script for ECS agent configuration
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${aws_ecs_cluster.main.name}" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_CONTAINER_METADATA=true" >> /etc/ecs/ecs.config
  EOF
  )

  bucket         = ""
  dynamodb_table = ""
  key            = ""

  tags = {
    Environment = terraform.workspace
    Name        = "ECS-Instance-EC2-Container-${terraform.workspace}-be"
  }
}

# --- Auto Scaling Group Module ---
module "ecs_autoscaling_group" {
  source              = "../modules/auto_scaling_group"
  launch_template_id  = module.launch_template.launch_template_id
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.vpc_zone_identifier
  name_tag            = var.asg
  target_group_arns   = [aws_lb_target_group.example.arn]

  tags = [
    {
      key                 = "Description"
      value               = "This instance is the part of the Auto Scaling group which was created through ECS Console"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "zaggle-${terraform.workspace}-fe-asg"
      propagate_at_launch = true
    }
  ]
}
