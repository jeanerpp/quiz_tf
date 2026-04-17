variable "tags" {
  # Common tags applied to all networking resources.
  type = map(string)
  description = "Tags for the network resources"
}

variable "vpc_id" {
  # Existing VPC where networking components are provisioned.
  type = string
  description = "VPC ID for the network deployment"
}

variable "igw_id" {
  # Internet gateway attached to the target VPC.
  type = string
  description = "IGW ID for the network deployment"
}

variable availability_zone {
  # Availability zones for the network deployment
  type = string
  description = "Availability zones for the network deployment"
}

variable "public_subnet_cidr" {
  # CIDR block for the public subnet in the availability zone.
  type = string
  description = "Public subnet cidr of the availability zone"
}

variable "control_subnet_cidr" {
  # CIDR block for the control subnet in the availability zone.
  type = string
  description = "Control subnet cidr of the availability zone"
}

variable "data_subnet_cidr" {
  # CIDR block for the data subnet in the availability zone.
  type = string
  description = "Data subnet cidr of the availability zone"
}
