terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "tencentcloud" {
  region = var.region["tencentcloud"]
  # Configuration for Tencent Cloud provider
}

provider "aws" {
  region  = var.region["aws"]
  profile = "default"
}