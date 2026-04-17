# Create public subnet for instances like NAT Gateway
resource "aws_subnet" "public_subnet" {
  vpc_id = var.vpc_id

  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = false  # only NAT Gateway will be in public subnet, so disable public IP assignment

  tags = var.tags
}

# Create control subnet for control plane instances like application servers
resource "aws_subnet" "control_subnet" {
    vpc_id = var.vpc_id

    cidr_block = var.control_subnet_cidr
    availability_zone = var.availability_zone

    tags = var.tags
}

# Create data subnet for data plane instances like databases
resource "aws_subnet" "data_subnet" {
    vpc_id = var.vpc_id

    cidr_block = var.data_subnet_cidr
    availability_zone = var.availability_zone

    tags = var.tags
}

# Elastic public IP for NAT gateway
resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = var.tags
}

# NAT Gateway for control/data networks internet access
resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet.id

    tags = var.tags
}

# Routing table to IGW
resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = var.tags
}

# Routing table to NAT Gateway
resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = var.tags
}

# Public subnet use IGW for internet
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Control subnet uses NAT gateway for internet
resource "aws_route_table_association" "control_subnet_assoc" {
  subnet_id      = aws_subnet.control_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Data subnet uses NAT gateway for internet
resource "aws_route_table_association" "data_subnet_assoc" {
  subnet_id      = aws_subnet.data_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
