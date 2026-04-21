This terraform project implements following feature.

Various env deployment
----
The project has 5 deployment envs: dev, test, prod, prod2, prod3.
Different envs has different dirs, which can have different terraform.tfvars and backend.tf.
In this way they can be isolated from each other, such tfstate and variables.
E.g. dev env uses local backend, while test env uses S3 backend.

Multi-tier architecture
----
The project implements multi-tier architecture.

The project is divided into three parts:
1. The first part is the load balancer, which is implemented by AWS ALB.
2. The second part is the web tier, which is implemented by AWS Auto Scaling Group.
3. The third part is the database tier, which is implemented by AWS RDS instances.

Multi-region
----
The project can be deployed in different regions, which can be configured in the terraform.tfvars file.

Multi-AZ
----
The project can be deployed in multiple availability zones, which can be configured in the terraform.tfvars file.

App deployment
----
Besides infra deployment, a bastion EC2 instance can be used to deploy the app to this env.
VPC peering is setup between bastion and this env, so that the bastion can access this env.

Exmaple
----
```
xujian@jasonpc:~/work/quiz_tf/envs/test$ terraform apply
module.computing.data.aws_ami.app_ami: Reading...
aws_vpc.vpc: Refreshing state... [id=vpc-015f0e87d65532146]
module.networking["ap-northeast-1a"].aws_eip.nat_eip: Refreshing state... [id=eipalloc-05316601a75238ff3]
module.networking["ap-northeast-1c"].aws_eip.nat_eip: Refreshing state... [id=eipalloc-0ecc7d6eefb213eb3]
module.computing.data.aws_ami.app_ami: Read complete after 1s [id=ami-0653588411d97b740]
aws_vpc_peering_connection.this_to_bastion: Refreshing state... [id=pcx-0b4485b4889606cb5]
module.networking["ap-northeast-1a"].aws_subnet.public_subnet: Refreshing state... [id=subnet-09c3afb8af57fa16c]
module.networking["ap-northeast-1c"].aws_subnet.public_subnet: Refreshing state... [id=subnet-000fd58f836007d6a]
aws_internet_gateway.igw: Refreshing state... [id=igw-0581d5f46af87b3f1]
aws_security_group.alb_sg: Refreshing state... [id=sg-020bf765f6bc57cf2]
module.computing.aws_lb_target_group.app_tg: Refreshing state... [id=arn:aws:elasticloadbalancing:ap-northeast-1:702536396247:targetgroup/app-tg/be94dd79bc22d29f]
module.networking["ap-northeast-1a"].aws_subnet.control_subnet: Refreshing state... [id=subnet-02b9ab96bf801a386]
module.networking["ap-northeast-1a"].aws_subnet.data_subnet: Refreshing state... [id=subnet-0109959383cb4e7fb]
module.networking["ap-northeast-1c"].aws_subnet.control_subnet: Refreshing state... [id=subnet-0427aad64234f877e]
module.networking["ap-northeast-1c"].aws_subnet.data_subnet: Refreshing state... [id=subnet-02410005dcd7649b9]
aws_security_group.app_sg: Refreshing state... [id=sg-0e3282d909b13e3c6]
module.networking["ap-northeast-1c"].aws_route_table.public_route_table: Refreshing state... [id=rtb-0c16a20d2815b5113]
module.networking["ap-northeast-1a"].aws_route_table.public_route_table: Refreshing state... [id=rtb-0c265628a50099918]
aws_vpc_peering_connection_options.peering_dns: Refreshing state... [id=pcx-0b4485b4889606cb5]
aws_route.bastion_to_this_vpc: Refreshing state... [id=r-rtb-070bb9e9616fefad4179966490]
module.networking["ap-northeast-1c"].aws_nat_gateway.nat_gateway: Refreshing state... [id=nat-0ebfb0880aa842767]
module.networking["ap-northeast-1a"].aws_nat_gateway.nat_gateway: Refreshing state... [id=nat-0d6cb9956ae983dd1]
module.networking["ap-northeast-1c"].aws_route_table_association.public_subnet_assoc: Refreshing state... [id=rtbassoc-0efbfa60240284ae3]
module.networking["ap-northeast-1a"].aws_route_table_association.public_subnet_assoc: Refreshing state... [id=rtbassoc-014de4d3305c0f61f]
aws_security_group.db_sg: Refreshing state... [id=sg-0d3e90bfaab8d80e9]
module.computing.aws_launch_template.app_lt: Refreshing state... [id=lt-030ea52b707feb515]
module.networking["ap-northeast-1c"].aws_route_table.private_route_table: Refreshing state... [id=rtb-0a0593ef4cce85145]
module.networking["ap-northeast-1a"].aws_route_table.private_route_table: Refreshing state... [id=rtb-069911fc9dc82b5d3]
module.networking["ap-northeast-1c"].aws_route_table_association.control_subnet_assoc: Refreshing state... [id=rtbassoc-0facd9659ddcea358]
module.networking["ap-northeast-1c"].aws_route_table_association.data_subnet_assoc: Refreshing state... [id=rtbassoc-0992cd522bec41810]
module.networking["ap-northeast-1a"].aws_route_table_association.control_subnet_assoc: Refreshing state... [id=rtbassoc-02e4e8e506b994f1b]
module.networking["ap-northeast-1a"].aws_route_table_association.data_subnet_assoc: Refreshing state... [id=rtbassoc-0d9ba7518050f8492]
module.computing.aws_lb.app_lb: Refreshing state... [id=arn:aws:elasticloadbalancing:ap-northeast-1:702536396247:loadbalancer/app/app-alb/0c1c40e58c985301]
module.computing.aws_autoscaling_group.app_asg: Refreshing state... [id=app-asg]
module.computing.aws_lb_listener.app_http: Refreshing state... [id=arn:aws:elasticloadbalancing:ap-northeast-1:702536396247:listener/app/app-alb/0c1c40e58c985301/12e42a39733bed83]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.data.aws_db_instance.app_db will be created
  + resource "aws_db_instance" "app_db" {
      + address                               = (known after apply)
      + allocated_storage                     = 20
      + apply_immediately                     = false
      + arn                                   = (known after apply)
      + auto_minor_version_upgrade            = true
      + availability_zone                     = (known after apply)
      + backup_retention_period               = (known after apply)
      + backup_target                         = (known after apply)
      + backup_window                         = (known after apply)
      + ca_cert_identifier                    = (known after apply)
      + character_set_name                    = (known after apply)
      + copy_tags_to_snapshot                 = false
      + db_name                               = (known after apply)
      + db_subnet_group_name                  = "app-db-subnet-group"
      + delete_automated_backups              = true
      + domain_fqdn                           = (known after apply)
      + endpoint                              = (known after apply)
      + engine                                = "mysql"
      + engine_version                        = "8.0"
      + engine_version_actual                 = (known after apply)
      + hosted_zone_id                        = (known after apply)
      + id                                    = (known after apply)
      + identifier                            = "app-db"
      + identifier_prefix                     = (known after apply)
      + instance_class                        = "db.t3.micro"
      + iops                                  = (known after apply)
      + kms_key_id                            = (known after apply)
      + latest_restorable_time                = (known after apply)
      + license_model                         = (known after apply)
      + listener_endpoint                     = (known after apply)
      + maintenance_window                    = (known after apply)
      + master_user_secret                    = (known after apply)
      + master_user_secret_kms_key_id         = (known after apply)
      + monitoring_interval                   = 0
      + monitoring_role_arn                   = (known after apply)
      + multi_az                              = (known after apply)
      + nchar_character_set_name              = (known after apply)
      + network_type                          = (known after apply)
      + option_group_name                     = (known after apply)
      + parameter_group_name                  = "default.mysql8.0"
      + password                              = (sensitive value)
      + performance_insights_enabled          = false
      + performance_insights_kms_key_id       = (known after apply)
      + performance_insights_retention_period = (known after apply)
      + port                                  = (known after apply)
      + publicly_accessible                   = false
      + replica_mode                          = (known after apply)
      + replicas                              = (known after apply)
      + resource_id                           = (known after apply)
      + skip_final_snapshot                   = true
      + snapshot_identifier                   = (known after apply)
      + status                                = (known after apply)
      + storage_throughput                    = (known after apply)
      + storage_type                          = "gp3"
      + tags                                  = {
          + "Environment" = "development"
          + "Name"        = "job-quiz"
        }
      + tags_all                              = {
          + "Environment" = "development"
          + "Name"        = "job-quiz"
        }
      + timezone                              = (known after apply)
      + username                              = "admin"
      + vpc_security_group_ids                = [
          + "sg-0d3e90bfaab8d80e9",
        ]
    }

  # module.data.aws_db_subnet_group.app_db will be created
  + resource "aws_db_subnet_group" "app_db" {
      + arn                     = (known after apply)
      + description             = "Managed by Terraform"
      + id                      = (known after apply)
      + name                    = "app-db-subnet-group"
      + name_prefix             = (known after apply)
      + subnet_ids              = [
          + "subnet-0109959383cb4e7fb",
          + "subnet-02410005dcd7649b9",
        ]
      + supported_network_types = (known after apply)
      + tags                    = {
          + "Environment" = "development"
          + "Name"        = "job-quiz"
        }
      + tags_all                = {
          + "Environment" = "development"
          + "Name"        = "job-quiz"
        }
      + vpc_id                  = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.data.aws_db_subnet_group.app_db: Creating...
module.data.aws_db_subnet_group.app_db: Creation complete after 2s [id=app-db-subnet-group]
module.data.aws_db_instance.app_db: Creating...
module.data.aws_db_instance.app_db: Still creating... [00m10s elapsed]
module.data.aws_db_instance.app_db: Still creating... [00m20s elapsed]
module.data.aws_db_instance.app_db: Still creating... [00m30s elapsed]
module.data.aws_db_instance.app_db: Still creating... [00m40s elapsed]
module.data.aws_db_instance.app_db: Still creating... [00m50s elapsed]
module.data.aws_db_instance.app_db: Still creating... [01m00s elapsed]
module.data.aws_db_instance.app_db: Still creating... [01m10s elapsed]
module.data.aws_db_instance.app_db: Still creating... [01m20s elapsed]
module.data.aws_db_instance.app_db: Still creating... [01m30s elapsed]
module.data.aws_db_instance.app_db: Still creating... [01m40s elapsed]
module.data.aws_db_instance.app_db: Still creating... [01m50s elapsed]
module.data.aws_db_instance.app_db: Still creating... [02m00s elapsed]
module.data.aws_db_instance.app_db: Still creating... [02m10s elapsed]
module.data.aws_db_instance.app_db: Still creating... [02m20s elapsed]
module.data.aws_db_instance.app_db: Still creating... [02m30s elapsed]
module.data.aws_db_instance.app_db: Still creating... [02m40s elapsed]
module.data.aws_db_instance.app_db: Still creating... [02m50s elapsed]
module.data.aws_db_instance.app_db: Still creating... [03m00s elapsed]
module.data.aws_db_instance.app_db: Still creating... [03m10s elapsed]
module.data.aws_db_instance.app_db: Still creating... [03m20s elapsed]
module.data.aws_db_instance.app_db: Still creating... [03m30s elapsed]
module.data.aws_db_instance.app_db: Still creating... [03m40s elapsed]
module.data.aws_db_instance.app_db: Still creating... [03m50s elapsed]
module.data.aws_db_instance.app_db: Still creating... [04m00s elapsed]
module.data.aws_db_instance.app_db: Still creating... [04m10s elapsed]
module.data.aws_db_instance.app_db: Still creating... [04m20s elapsed]
module.data.aws_db_instance.app_db: Still creating... [04m30s elapsed]
module.data.aws_db_instance.app_db: Still creating... [04m40s elapsed]
module.data.aws_db_instance.app_db: Still creating... [04m50s elapsed]
module.data.aws_db_instance.app_db: Still creating... [05m00s elapsed]
module.data.aws_db_instance.app_db: Still creating... [05m10s elapsed]
module.data.aws_db_instance.app_db: Creation complete after 5m16s [id=db-AXIOG3JCLDOVFDNJWSBUN7WNOQ]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

app_lb_url = "http://app-alb-1010281903.ap-northeast-1.elb.amazonaws.com"
````