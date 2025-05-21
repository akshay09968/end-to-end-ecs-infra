# --- Target Group Configuration ---
resource "aws_lb_target_group" "example" {
  name        = var.target_group
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/" # Update this to match your application's health check endpoint
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"
  }

  tags = {
    Name        = "${terraform.workspace}-frontend-tg"
    Environment = terraform.workspace
  }
}

# --- ALB HTTPS Listener ---
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = var.load_balancer_arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

# --- ALB Listener Rule ---
resource "aws_lb_listener_rule" "example_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }

  condition {
    host_header {
      values = var.host_header
    }
  }

  condition {
    path_pattern {
      values = var.path_pattern
    }
  }
}
