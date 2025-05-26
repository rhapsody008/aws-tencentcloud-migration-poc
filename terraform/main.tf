module "aws_infrastructure_dev" {
  source = "./modules/aws"

  aws_region          = var.region["aws"]
  aws_instance_type   = "c6a.large"
  aws_instance_ami_id = "ami-01938df366ac2d954" # Ubuntu Server 24.04 LTS
  aws_resource_prefix = "zydev-"

  aws_vpc_cidr     = var.vpc_cidr
  aws_subnet1_cidr = var.subnet1_cidr
  aws_subnet2_cidr = var.subnet2_cidr
}

output "aws_dev_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.aws_infrastructure_dev.aws_alb_dns_name
}

module "tencentcloud_infrastructure" {
  source = "./modules/tencentcloud"

  tencentcloud_region       = var.region["tencentcloud"]
  tencentcloud_vpc_cidr     = var.vpc_cidr
  tencentcloud_subnet1_cidr = var.subnet1_cidr
  tencentcloud_subnet2_cidr = var.subnet2_cidr
}

