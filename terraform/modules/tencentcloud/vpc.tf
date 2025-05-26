data "tencentcloud_availability_zones" "available" {
  include_unavailable = false
}

resource "tencentcloud_vpc" "zy_test_tencentcloud_vpc" {
  name       = "zy_test_tencentcloud_vpc"
  cidr_block = var.tencentcloud_vpc_cidr
}

resource "tencentcloud_subnet" "zy_test_tencentcloud_subnet1" {
  name              = "zy_test_tencentcloud_subnet1"
  vpc_id            = tencentcloud_vpc.zy_test_tencentcloud_vpc.id
  cidr_block        = var.tencentcloud_subnet1_cidr
  availability_zone = data.tencentcloud_availability_zones.available.name[0]
}

resource "tencentcloud_subnet" "zy_test_tencentcloud_subnet2" {
  name              = "zy_test_tencentcloud_subnet2"
  vpc_id            = tencentcloud_vpc.zy_test_tencentcloud_vpc.id
  cidr_block        = var.tencentcloud_subnet2_cidr
  availability_zone = data.tencentcloud_availability_zones.available.name[1]
}

resource "tencentcloud_route_table" "zy_test_tencentcloud_route_table" {
  name   = "zy_test_tencentcloud_route_table"
  vpc_id = tencentcloud_vpc.zy_test_tencentcloud_vpc.id
}

resource "tencentcloud_route_table_association" "zy_test_tencentcloud_rta1" {
  subnet_id      = tencentcloud_subnet.zy_test_tencentcloud_subnet1.id
  route_table_id = tencentcloud_route_table.zy_test_tencentcloud_route_table.id
}

resource "tencentcloud_route_table_association" "zy_test_tencentcloud_rta2" {
  subnet_id      = tencentcloud_subnet.zy_test_tencentcloud_subnet2.id
  route_table_id = tencentcloud_route_table.zy_test_tencentcloud_route_table.id
}

resource "tencentcloud_security_group" "zy_test_tencentcloud_sg" {
  name        = "zy_test_tencentcloud_security_group"
  description = "Security group for CVM instances"
}

resource "tencentcloud_security_group_rule_set" "zy_test_tencentcloud_sg_rule_set" {
  security_group_id = tencentcloud_security_group.zy_test_tencentcloud_sg.id

  ingress {
    action      = "ACCEPT"
    cidr_block  = "0.0.0.0/0"
    protocol    = "TCP"
    port        = "22"
    description = "Allow SSH"
  }

  ingress {
    action      = "ACCEPT"
    cidr_block  = "0.0.0.0/0"
    protocol    = "TCP"
    port        = "80"
    description = "Allow HTTP"
  }

  ingress {
    action      = "ACCEPT"
    cidr_block  = "0.0.0.0/0"
    protocol    = "TCP"
    port        = "443"
    description = "Allow HTTPS"
  }

  egress {
    action     = "ACCEPT"
    cidr_block = "0.0.0.0/0"
    protocol   = "ALL"
  }
}
