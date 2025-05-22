variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "c7a.large"
}

variable "aws_resource_prefix" {
  description = "The prefix for AWS resources"
  type        = string
  default     = "zy_test_"
}

variable "aws_vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = ""
}

variable "aws_instance_ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
  default     = "ami-01938df366ac2d954" # Ubuntu Server 24.04 LTS
}