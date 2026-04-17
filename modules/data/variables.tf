variable "tags" {
  # Common tags applied to data-layer resources.
  type = map(string)
  description = "Tags for the network resources"
}

variable "data_subnet_ids" {
  # Private subnet IDs where data services are deployed.
  type = list(string)
  description = "List of data subnet IDs for the data module"
}

variable "data_sg_id" {
  # Security group attached to database resources.
  type = string
  description = "Security Group ID for the data instances"
}

variable "db_username" {
  # Master username for the database instance.
  type = string
  description = "Username for the RDS database"
}

variable "db_password" {
  # Master password for the database instance.
  type = string
  description = "Password for the RDS database"
}
