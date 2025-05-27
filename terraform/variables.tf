variable "vpc_cidr" {
  description = "value for vpc cidr"
  type        = string
}

variable "subnet1_cidr" {
  description = "value for subnet 1 cidr"
  type        = string
}

variable "subnet2_cidr" {
  description = "value for subnet 2 cidr"
  type        = string
}

variable "aws_config" {
  description = "AWS config options"
  type = object({
    region          = string
    instance_type   = string
    image_id        = string
    resource_prefix = string
  })
}

variable "tencentcloud_config" {
  description = "Tencent Cloud config options"
  type = object({
    region        = string
    instance_type = string
    image_id      = string
  })
}
