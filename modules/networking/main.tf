resource "aws_subnet" "public-subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.az.public_subnet_cidr
  availability_zone = var.az.availability_zone
  map_public_ip_on_launch = false  # only NAT Gateway will be in public subnet, so disable public IP assignment
  tags = var.tags
}

resource "aws_subnet" "control-subnet" {
    vpc_id = var.vpc_id
    cidr_block = var.az.control_subnet_cidr
    availability_zone = var.az.availability_zone
    tags = var.tags
}

resource "aws_subnet" "data-subnet" {
    vpc_id = var.vpc_id
    cidr_block = var.az.data_subnet_cidr
    availability_zone = var.az.availability_zone
    tags = var.tags
}
    
resource "aws_eip" "eip" {
    domain = "vpc"
    tags = var.tags
}

resource "aws_nat_gateway" "nat-gateway" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public-subnet.id
    tags = var.tags
}

resource "aws_route_table" "public-route-table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = var.tags
}

resource "aws_route_table" "private-route-table" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = var.tags
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
