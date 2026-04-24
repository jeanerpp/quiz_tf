config = {
    tags = {
        Environment = "development"
        Name = "job-quiz"
    }

    region =  "ap-northeast-1"

    vpc = {
        cidr_block = "10.0.0.0/16"
        enable_dns_support = true
        enable_dns_hostnames = true
        peer_vpc_id = "vpc-09f65a9171dbc2152"
        peer_vpc_cidr = "172.31.0.0/16"
        peer_vpc_route_table_id = "rtb-070bb9e9616fefad4"
    }
    azs = [
            {
                availability_zone = "ap-northeast-1a"
                public_subnet_cidr = "10.0.0.0/24"
                control_subnet_cidr = "10.0.1.0/24"
                data_subnet_cidr = "10.0.2.0/24"
            },
            {
                availability_zone = "ap-northeast-1c"
                public_subnet_cidr = "10.0.10.0/24"
                control_subnet_cidr = "10.0.11.0/24"
                data_subnet_cidr = "10.0.12.0/24"
            }
    ]
    ec2 = {
        ami_name_filter = "ubuntu-*-amd64-server-*"
        ec2_instance_type = "t3.micro"
        asg_desired_capacity = 2
        asg_min_size = 2
        asg_max_size = 2
        ssh_key_name = "bastion"
        ec2_role_instance_profile = "arn:aws:iam::702536396247:instance-profile/S3Readonly"
    }
    db = {
        username = "admin"
        instance_class = "db.t3.micro"
        allocated_storage = 20
        storage_type = "gp3"
        skip_final_snapshot = "true"
    }
}