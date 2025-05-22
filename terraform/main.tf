module "aws_infrastructure_dev" {
  source = "./modules/aws"

  aws_region          = var.region["aws"]
  aws_instance_type   = "c6a.large"
  aws_instance_ami_id = "ami-01938df366ac2d954" # Ubuntu Server 24.04 LTS
  aws_resource_prefix = "zydev-"

  aws_vpc_cidr     = "10.0.0.0/16"
  aws_subnet_cidr1 = "10.0.1.0/24"
  aws_subnet_cidr2 = "10.0.2.0/24"
}

output "aws_dev_dns_name" {
    description = "The DNS name of the ALB"
    value       = module.aws_infrastructure_dev.aws_alb_dns_name
}

# module "tencentcloud_infrastructure" {
#     source = "./modules/tencentcloud"

#     # Add required variables for the module
#     # Example:
#     # region = "us-east-1"
#     # instance_type = "t2.micro"
# }

