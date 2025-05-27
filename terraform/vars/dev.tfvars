vpc_cidr = "10.0.0.0/16"
subnet1_cidr = "10.0.1.0/24"
subnet2_cidr = "10.0.2.0/24"

aws_config = {
  region          = "ap-southeast-1"
  instance_type   = "c6a.large"
  image_id        = "ami-01938df366ac2d954" # Ubuntu Server 24.04 LTS
  resource_prefix = "zydev-"
}

tencentcloud_config = {
  region        = "ap-singapore"
  instance_type = "SA5.LARGE8"
  image_id      = "img-mmytdhbn" # Ubuntu Server 24.04 LTS
}