variable "config" {
  type = object({
    tags = map(string)
    region = string
    vpc = object({
      cidr_block           = string
      enable_dns_support   = bool
      enable_dns_hostnames = bool
    })
    public-net = object({
      subnet_cidr_block = string
      availability_zone = string
    })
    control-net = object({
      subnet_cidr_block = string
      availability_zone = string
    })
    data-net = object({
      subnet_cidr_block = string
      availability_zone = string
    })
  })
  description = "Configuration for the deployment"
}
