module "aws_infrastructure" {
    source = "../../modules/aws"

    # Add required variables for the module
    # Example:
    # region = "us-east-1"
    # instance_type = "t2.micro"
}

module "tencentcloud_infrastructure" {
    source = "../../modules/tencentcloud"

    # Add required variables for the module
    # Example:
    # region = "us-east-1"
    # instance_type = "t2.micro"
}

