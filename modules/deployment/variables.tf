variable "config" {
  # Full deployment configuration passed from the root environment stack.
  type = object({
    # Tags propagated to all underlying modules.
    tags = map(string)

    # Region used by resources in this deployment.
    region = string

    # VPC-level configuration shared by child modules.
    vpc = object({
      cidr_block           = string
      enable_dns_support   = bool
      enable_dns_hostnames = bool
    })

    # Availability-zone subnet layout consumed by networking and compute.
    azs = list(object({
      availability_zone = string
      public_subnet_cidr = string
      control_subnet_cidr = string
      data_subnet_cidr = string
    }))

    # EC2 naming and count settings.
    ec2 = object({
      name_prefix = string
      count       = number
    })

    # Database credentials for the data module.
    db = object({
      username = string
      password = string
    })
  })
  description = "Configuration for the deployment"
}
