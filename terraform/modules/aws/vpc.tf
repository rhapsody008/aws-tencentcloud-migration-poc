resource "aws_vpc" "zy_test_aws_vpc" {
    cidr_block           = var.aws_vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "zy_test_aws_vpc"
    }
}

resource "aws_subnet" "zy_test_aws_subnet" {
    vpc_id                  = aws_vpc.zy_test_aws_vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"
    tags = {
        Name = "zy_test_aws_subnet"
    }
}

resource "aws_internet_gateway" "zy_test_aws_igw" {
    vpc_id = aws_vpc.zy_test_aws_vpc.id
    tags = {
        Name = "zy_test_aws_igw"
    }
}

resource "aws_route_table" "zy_test_aws_route_table" {
    vpc_id = aws_vpc.zy_test_aws_vpc.id
    tags = {
        Name = "zy_test_aws_route_table"
    }
}

resource "aws_route" "zy_test_aws_route" {
    route_table_id         = aws_route_table.zy_test_aws_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.zy_test_aws_igw.id
}

resource "aws_route_table_association" "zy_test_aws_rta" {
    subnet_id      = aws_subnet.zy_test_aws_subnet.id
    route_table_id = aws_route_table.zy_test_aws_route_table.id
}