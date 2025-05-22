variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "aws_instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
}

variable "aws_resource_prefix" {
  description = "The prefix for AWS resources"
  type        = string
}

variable "aws_vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "aws_subnet_cidr1" {
  description = "The CIDR block for the subnet1"
  type        = string
}

variable "aws_subnet_cidr2" {
  description = "The CIDR block for the subnet2"
  type        = string
}

variable "aws_instance_ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
}