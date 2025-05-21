################################################################################
# Terraform Version (current)
################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

################################################################################
# AWS Provider
################################################################################

provider "aws" {
  profile = "default"
  region  = "ap-south-2"
}

# --- Define Availability Zones ---
data "aws_availability_zones" "available" {
  state = "available"
}

# --- Local Variables ---
locals {
  workspace_env = substr(terraform.workspace, 0, 3) // Use only the first 3 characters
  azs_count     = 2
  azs_names     = data.aws_availability_zones.available.names
}


################################################################################
# Security groups
################################################################################

resource "aws_security_group" "ecs_service" {
  name_prefix = "${local.workspace_env}-ecs-sg-"
  description = "ECS service security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "http" {
  name_prefix = "${local.workspace_env}-http-sg-"
  description = "Allow all HTTP/HTTPS traffic"
  #   vpc_id      = "vpc-0b9d14795eb6af41d"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = [80, 443]
    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {
  name_prefix = "${local.workspace_env}-ssh-sg-"
  description = "Allow SSH access"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



