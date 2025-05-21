# resource "aws_ecs_service" "frontend" {
#   name            = var.name
#   cluster         = var.cluster_id
#   task_definition = var.task_definition
#   desired_count   = var.desired_count
#   launch_type     = "EC2"
#
#   # Health check addition for target group fix (testing phase)
#   health_check_grace_period_seconds = 300
#
#   placement_constraints {
#     type = "distinctInstance"
#   }
#
#   lifecycle {
#     ignore_changes = [
#       desired_count,
#       task_definition
#     ]
#   }
# }
#
# # Output the ECS service name for reference
# output "ecs_service_name" {
#   value = aws_ecs_service.frontend.name
# }

resource "aws_ecs_service" "frontend" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = var.task_definition
  desired_count   = var.desired_count
  launch_type     = "EC2"

  # Enable dynamic port mapping with target group integration
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port # This should match the `containerPort` in the task definition
  }

  # Health check configuration
  health_check_grace_period_seconds = 300

  placement_constraints {
    type = "distinctInstance"
  }

  # Lifecycle configuration to ignore changes
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition
    ]
  }

  # Tags to help identify resources
  tags = {
    Environment = var.environment
  }
}

# Output the ECS service name for reference
output "ecs_service_name" {
  value = aws_ecs_service.frontend.name
}
