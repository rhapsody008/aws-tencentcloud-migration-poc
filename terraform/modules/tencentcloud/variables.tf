variable "tencentcloud_region" {
  description = "The Tencent Cloud region to deploy resources in"
  type        = string
}

variable "tencentcloud_vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "tencentcloud_subnet1_cidr" {
  description = "The CIDR block for the subnet1"
  type        = string
}

variable "tencentcloud_subnet2_cidr" {
  description = "The CIDR block for the subnet2"
  type        = string
}

variable "tencentcloud_cvm_image_id" {
    description = "The image ID for the CVM instances"
    type        = string
}

variable "tencentcloud_cvm_instance_type" {
    description = "The instance type for the CVM instances"
    type        = string
}