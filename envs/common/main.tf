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

# Security Group: EC2 (only from ALB and bastion)
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow 80 from ALB and SSH from bastion"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "Allow HTTP from ALB"
  }

  # ingress {
  #   from_port       = 22
  #   to_port         = 22
  #   protocol        = "tcp"
  #   security_groups = [var.config.bastion_sg_id]
  #   description     = "Allow SSH from bastion"
  # }

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
  source   = "../../modules/networking"

  tags     = var.config.tags
  vpc_id   = aws_vpc.vpc.id
  igw_id   = aws_internet_gateway.igw.id
  for_each = { for az in var.config.azs : az.availability_zone => az }
  availability_zone   = each.value.availability_zone
  public_subnet_cidr  = each.value.public_subnet_cidr
  control_subnet_cidr = each.value.control_subnet_cidr
  data_subnet_cidr    = each.value.data_subnet_cidr
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


module "data" {
  source   = "../../modules/data"

  tags     = var.config.tags
  data_subnet_ids = values(local.data_subnet_ids)
  data_sg_id = aws_security_group.db_sg.id
  db_username = var.config.db.username
  db_password = var.config.db.password
  storage_type = var.config.db.storage_type
  allocated_storage = var.config.db.allocated_storage
  instance_class = var.config.db.instance_class
  skip_final_snapshot = var.config.db.skip_final_snapshot
}


module "computing" {
  source   = "../../modules/computing"

  tags     = var.config.tags
  vpc_id   = aws_vpc.vpc.id
  igw_id   = aws_internet_gateway.igw.id
  public_subnet_ids = values(local.public_subnet_ids)
  control_subnet_ids = values(local.control_subnet_ids)
  alb_sg_id = aws_security_group.alb_sg.id
  app_sg_id = aws_security_group.app_sg.id

  ami_name_filter = var.config.ec2.ami_name_filter
  ec2_instance_type = var.config.ec2.ec2_instance_type
  asg_desired_capacity = var.config.ec2.asg_desired_capacity
  asg_min_size = var.config.ec2.asg_min_size
  asg_max_size = var.config.ec2.asg_max_size

  ssh_key_name = var.config.ec2.ssh_key_name
}


output "app_lb_url" {
  value = "http://${module.computing.app_lb_dns}"
}