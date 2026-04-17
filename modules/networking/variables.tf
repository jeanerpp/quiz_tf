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

variable "az" {
  # Subnet CIDR plan for one availability zone.
  type = object({
    availability_zone = string
    public_subnet_cidr = string
    control_subnet_cidr = string
    data_subnet_cidr = string
  })
  description = "Configuration for networking module"
}
