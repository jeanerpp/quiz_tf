resource "aws_db_subnet_group" "db" {
  name       = "db-subnet-group"
  subnet_ids = var.data_subnet_ids
}

resource "aws_db_instance" "db" {
  identifier             = "app-db"
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "password123"
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [var.data_sg_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
}