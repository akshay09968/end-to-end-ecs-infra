provider "aws" {
  region = var.region
}

resource "aws_security_group" "zaggle_prod" {
  alb_sg_name = var.alb_sg_name
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_alb
  }
}

resource "aws_lb" "example_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.zaggle_prod.id]
  subnets            = var.subnets

  enable_deletion_protection = false
}
