################################################################################
# Security Groups
################################################################################

output "http_sg_id" {
  value = aws_security_group.http.id
}

output "ssh_sg_id" {
  value = aws_security_group.ssh.id
}

################################################################################
# Cluster
################################################################################

output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}

################################################################################
# Service(s)
################################################################################

output "ecs_task_definition_arn_frontend" {
  value = aws_ecs_task_definition.frontend.arn
}


output "ecs_service_sg_id" {
  value = aws_security_group.ecs_service.id
}

################################################################################
# Target group
################################################################################

output "target_group_arn" {
  value = aws_lb_target_group.example.arn
}


################################################################################
# Launch template
################################################################################

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = module.ecs_service_frontend.ecs_service_name
}

output "launch_template_id" {
  value = module.launch_template.launch_template_id
}