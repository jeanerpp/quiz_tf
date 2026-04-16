data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
}

resource "aws_network_interface" "control_nic" {
  count = var.config.ec2.count
  subnet_id       = var.config.vpc.control-net.subnet_id
  security_groups = [var.config.vpc.control-net.sg_id]

  tags = {
    Name = "${var.config.ec2.name_prefix}-control-nic-${count.index}"
  }
}

resource "aws_network_interface" "data_nic" {
  count = var.config.ec2.count
  subnet_id       = var.config.vpc.data-net.subnet_id
  security_groups = [var.config.vpc.data-net.sg_id]

  tags = {
    Name = "${var.config.ec2.name_prefix}-data-nic-${count.index}"
  }
}

resource "aws_instance" "test-ec2" {
  count         = var.config.ec2.count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.control_nic[count.index].id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.data_nic[count.index].id
    device_index         = 1
  }

  tags = {
    Name = "${var.config.ec2.name_prefix}-${count.index}"
  }
}