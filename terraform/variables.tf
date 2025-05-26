variable "region" {
  type = map(string)
  default = {
    aws          = "ap-southeast-1"
    tencentcloud = "ap-singapore"
  }
}

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