variable "tags" {
  type = map(string)
  description = "Tags for the network resources"
}

variable "data_subnet_ids" {
  type = list(string)
  description = "List of data subnet IDs for the data module"
}

variable "data_sg_id" {
  type = string
  description = "Security Group ID for the data instances"
}

variable "db_username" {
  type = string
  description = "Username for the RDS database"
}

variable "db_password" {
  type = string
  description = "Password for the RDS database"
}
