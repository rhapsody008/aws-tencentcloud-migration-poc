module "aws_infrastructure" {
  source = "./modules/aws"

  aws_region          = var.aws_config.region
  aws_instance_type   = var.aws_config.instance_type
  aws_instance_ami_id = var.aws_config.image_id
  aws_resource_prefix = var.aws_config.resource_prefix

  aws_vpc_cidr     = var.vpc_cidr
  aws_subnet1_cidr = var.subnet1_cidr
  aws_subnet2_cidr = var.subnet2_cidr
}

output "aws_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.aws_infrastructure.aws_alb_dns_name
}

module "tencentcloud_infrastructure" {
  source = "./modules/tencentcloud"

  tencentcloud_region            = var.tencentcloud_config.region
  tencentcloud_cvm_instance_type = var.tencentcloud_config.instance_type
  tencentcloud_cvm_image_id      = var.tencentcloud_config.image_id

  tencentcloud_vpc_cidr     = var.vpc_cidr
  tencentcloud_subnet1_cidr = var.subnet1_cidr
  tencentcloud_subnet2_cidr = var.subnet2_cidr
}

output "tencentcloud_vips" {
  description = "The VIPs of the CVM instances"
  value       = module.tencentcloud_infrastructure.tencentcloud_clb_vips
}

output "tencentcloud_dns_name" {
  description = "The DNS name of the CVM instances"
  value       = module.tencentcloud_infrastructure.tencentcloud_clb_domain
}

