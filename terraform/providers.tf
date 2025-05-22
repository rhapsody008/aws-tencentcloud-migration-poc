terraform {
    required_providers {
        tencentcloud = {
            source  = "tencentcloud/tencentcloud"
            version = "~> 1.0"
        }
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}

provider "tencentcloud" {
    region = var.region["tencentcloud"]
    # Configuration for Tencent Cloud provider
}

provider "aws" {
    region = var.region["aws"]
    # Configuration for AWS provider
}