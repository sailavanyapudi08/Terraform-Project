terraform {
  # stores the terraform state file in s3
  backend "s3" {
    bucket         = "to-store-tf-state"
    key            = "basics/web-app/terraform.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# configure aws provider
provider "aws" {
  region = "ca-central-1"
}

locals {
  extra_tag = "extra-tag"
}

#To dynamically fetch the ami's from aws
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}