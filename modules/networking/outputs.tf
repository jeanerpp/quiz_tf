output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "control_subnet_id" {
  value = aws_subnet.control_subnet.id
}

output "data_subnet_id" {
  value = aws_subnet.data_subnet.id
}
