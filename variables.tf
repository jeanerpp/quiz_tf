variable "config" {
  type = object({
    tags = map(string)
    region = string
    vpc = object({
      cidr_block           = string
      enable_dns_support   = bool
      enable_dns_hostnames = bool
    })
    azs = list(object({
      availability_zone = string
      public_subnet_cidr = string
      control_subnet_cidr = string
      data_subnet_cidr = string
    }))
    ec2 = object({
      name_prefix = string
      count       = number
    })
  })
  description = "Configuration for the deployment"
}
