output "public_subnet_id" {
  value = aws_subnet.public-subnet.id
}

output "control_subnet_id" {
  value = aws_subnet.control-subnet.id
}

output "data_subnet_id" {
  value = aws_subnet.data-subnet.id
}
