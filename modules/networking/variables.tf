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

variable "az" {
  type = object({
    availability_zone = string
    public_subnet_cidr = string
    control_subnet_cidr = string
    data_subnet_cidr = string
  })
  description = "Configuration for networking module"
}
