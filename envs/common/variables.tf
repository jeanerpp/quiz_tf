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
      peer_vpc_id          = string
      peer_vpc_cidr        = string
      peer_vpc_route_table_id = string
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
      ami_name_filter = string
      ec2_instance_type = string
      asg_desired_capacity = number
      asg_min_size = number
      asg_max_size = number
      ssh_key_name = string
    })

    # Database credentials for the data module.
    db = object({
      username = string
      password = string
      instance_class = string
      allocated_storage = number
      storage_type = string
      skip_final_snapshot = string
    })

    bastion_sg_id = string
  })
  description = "Configuration for the deployment"
}
