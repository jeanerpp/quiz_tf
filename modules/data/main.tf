# Create db subnet group
resource "aws_db_subnet_group" "app_db" {
  name       = "app-db-subnet-group"
  subnet_ids = var.data_subnet_ids

  tags = var.tags
}

# Create RDS MySQL instance
resource "aws_db_instance" "app_db" {
  identifier             = "app-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_class
  
  db_name                = "quiz"

  # storage configuration
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  
  # authentication configuration
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  
  # network configuration
  db_subnet_group_name   = aws_db_subnet_group.app_db.name
  vpc_security_group_ids = [var.data_sg_id]
  publicly_accessible    = false
  
  # backup and snapshot configuration
  skip_final_snapshot    = var.skip_final_snapshot
  
  # tags
  tags = var.tags
}

# Output RDS connection information
output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.app_db.endpoint
}

output "db_port" {
  description = "RDS instance port"
  value       = aws_db_instance.app_db.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.app_db.db_name
}

output "db_username" {
  description = "Database username"
  value       = aws_db_instance.app_db.username
}
