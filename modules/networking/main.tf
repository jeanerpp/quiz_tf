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

resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.config.public-net.subnet_cidr_block
  availability_zone = var.config.public-net.availability_zone
  map_public_ip_on_launch = false  # only NAT Gateway will be in public subnet, so disable public IP assignment
  tags = var.config.tags
}

resource "aws_subnet" "control-subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.config.control-net.subnet_cidr_block
    availability_zone = var.config.control-net.availability_zone
    tags = var.config.tags
}

resource "aws_subnet" "data-subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.config.data-net.subnet_cidr_block
    availability_zone = var.config.data-net.availability_zone
    tags = var.config.tags
}
    
resource "aws_security_group" "control-plane-sg" {
    name = "control-plane-sg"
    description = "Security group for control plane"
    vpc_id = aws_vpc.vpc.id

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = var.config.tags
}

resource "aws_security_group" "data-plane-sg" {
    name = "data-plane-sg"
    description = "Security group for data plane"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.config.vpc.cidr_block]
      }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.config.vpc.cidr_block]
      }
    tags = var.config.tags
}

resource "aws_eip" "eip" {
    domain = "vpc"
    tags = var.config.tags
}

resource "aws_nat_gateway" "nat-gateway" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public-subnet.id
    tags = var.config.tags
    depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.config.tags
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = var.config.tags
}

resource "aws_route_table_association" "public-subnet-assoc" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "control-subnet-assoc" {
  subnet_id      = aws_subnet.control-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "data-subnet-assoc" {
  subnet_id      = aws_subnet.data-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}
