resource "aws_vpc" "web_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "web-vpc"
  }
}


# Public and Private Subnets
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ca-central-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ca-central-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ca-central-1a"
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ca-central-1b"
}
