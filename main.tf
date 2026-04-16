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

module "networking" {
  source   = "./modules/networking"

  tags     = var.config.tags
  vpc_id   = aws_vpc.vpc.id
  igw_id   = aws_internet_gateway.igw.id
  for_each = { for az in var.config.azs : az.availability_zone => az }
  az       = each.value
}
