variable "tags" {
  # Common tags applied to compute resources.
  type = map(string)
  description = "Tags for the network resources"
}
variable "vpc_id" {
  # VPC where compute components are created.
  type = string
  description = "VPC ID for the network deployment"
}

variable "igw_id" {
  # Internet gateway used by public-facing compute resources.
  type = string
  description = "IGW ID for the network deployment"
}

variable "ami_name_filter" {
  # Name pattern used to select an AMI for EC2 instances.
  type = string
  description = "Filter for the AMI name to use for EC2 instances"
}

variable public_subnet_ids {
  # Public subnet IDs used for external-facing compute components.
  type = list(string)
  description = "List of public subnet IDs for the computing module"
}

variable control_subnet_ids {
  # Private/control subnet IDs used for application instances.
  type = list(string)
  description = "List of control subnet IDs for the computing module"
}

variable "alb_sg_id" {
  # Security group assigned to the application load balancer.
  type = string
  description = "Security Group ID for the ALB"
}

variable "app_sg_id" {
  # Security group assigned to application EC2 instances.
  type = string
  description = "Security Group ID for the application instances"
}
