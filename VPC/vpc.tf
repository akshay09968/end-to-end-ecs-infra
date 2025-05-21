terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
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
# VPC
################################################################################

# --- VPC ---
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "zaggle-prod-vpc" }
}

# --- Public Subnets ---
resource "aws_subnet" "public" {
  count                   = local.azs_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = local.azs_names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  tags                    = { Name = "zaggle-prod-public-${local.azs_names[count.index]}" }
}

# --- Private Subnets ---
resource "aws_subnet" "private" {
  count                   = local.azs_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = local.azs_names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 10 + count.index)
  map_public_ip_on_launch = false
  tags                    = { Name = "zaggle-prod-private-${local.azs_names[count.index]}" }
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "zaggle-prod-igw" }
}

# --- Elastic IPs (for NAT Gateway) ---
resource "aws_eip" "main" {
  count      = local.azs_count
  depends_on = [aws_internet_gateway.main]
  tags       = { Name = "zaggle-prod-eip-${local.azs_names[count.index]}" }
}

# --- NAT Gateway ---
resource "aws_nat_gateway" "main" {
  count         = local.azs_count
  allocation_id = aws_eip.main[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags          = { Name = "zaggle-prod-nat-${local.azs_names[count.index]}" }
}

# --- Public Route Table ---
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "zaggle-prod-rt-public" }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# --- Associate Route Table with Public Subnets ---
resource "aws_route_table_association" "public" {
  count          = local.azs_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# --- Private Route Table ---
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "zaggle-prod-rt-private" }
}

resource "aws_route_table_association" "private" {
  count          = local.azs_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
