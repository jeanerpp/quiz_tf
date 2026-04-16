provider "aws" {
  region = var.config.region
}

resource "aws_vpc" "vpc" {
    cidr_block = var.config.vpc.cidr_block
    enable_dns_support = var.config.vpc.enable_dns_support
    enable_dns_hostnames = var.config.vpc.enable_dns_hostnames
    tags = var.config.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = var.config.tags
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP from internet"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group: EC2 (only from ALB)
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow 80 from ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group: RDS (only from app)
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow 3306 from app"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "networking" {
  source   = "./modules/networking"

  tags     = var.config.tags
  vpc_id   = aws_vpc.vpc.id
  igw_id   = aws_internet_gateway.igw.id
  for_each = { for az in var.config.azs : az.availability_zone => az }
  az       = each.value
}

locals {
  public_subnet_ids = {
    for az, config in module.networking : az => config.public_subnet_id
  }
  control_subnet_ids = {
    for az, config in module.networking : az => config.control_subnet_id
  }
  data_subnet_ids = {
    for az, config in module.networking : az => config.data_subnet_id
  }
}


module "computing" {
  source   = "./modules/computing"

  tags     = var.config.tags
  vpc_id   = aws_vpc.vpc.id
  igw_id   = aws_internet_gateway.igw.id
  public_subnet_ids = values(local.public_subnet_ids)
  control_subnet_ids = values(local.control_subnet_ids)
  ami_name_filter = "ubuntu-*-amd64-server-*"
  alb_sg_id = aws_security_group.alb_sg.id
  app_sg_id = aws_security_group.app_sg.id
}

module "data" {
  source   = "./modules/data"

  tags     = var.config.tags
  data_subnet_ids = values(local.data_subnet_ids)
  data_sg_id = aws_security_group.db_sg.id
}