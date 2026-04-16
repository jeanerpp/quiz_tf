variable "tags" {
  type = map(string)
  description = "Tags for the network resources"
}
variable "vpc_id" {
  type = string
  description = "VPC ID for the network deployment"
}

variable "igw_id" {
  type = string
  description = "IGW ID for the network deployment"
}

variable "ami_name_filter" {
  type = string
  description = "Filter for the AMI name to use for EC2 instances"
}

variable public_subnet_ids {
  type = list(string)
  description = "List of public subnet IDs for the computing module"
}

variable control_subnet_ids {
  type = list(string)
  description = "List of control subnet IDs for the computing module"
}

variable "alb_sg_id" {
  type = string
  description = "Security Group ID for the ALB"
}

variable "app_sg_id" {
  type = string
  description = "Security Group ID for the application instances"
}
