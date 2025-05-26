data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "zy_test_aws_vpc" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "zy_test_aws_vpc"
  }
}

resource "aws_subnet" "zy_test_aws_subnet1" {
  vpc_id                  = aws_vpc.zy_test_aws_vpc.id
  cidr_block              = var.aws_subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "zy_test_aws_subnet1"
  }
}

resource "aws_subnet" "zy_test_aws_subnet2" {
  vpc_id                  = aws_vpc.zy_test_aws_vpc.id
  cidr_block              = var.aws_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "zy_test_aws_subnet2"
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

resource "aws_route_table_association" "zy_test_aws_rta1" {
  subnet_id      = aws_subnet.zy_test_aws_subnet1.id
  route_table_id = aws_route_table.zy_test_aws_route_table.id
}

resource "aws_route_table_association" "zy_test_aws_rta2" {
  subnet_id      = aws_subnet.zy_test_aws_subnet2.id
  route_table_id = aws_route_table.zy_test_aws_route_table.id
}


resource "aws_security_group" "zy_test_aws_sg" {
  name_prefix = var.aws_resource_prefix
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.zy_test_aws_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
