data "aws_availability_zones" "available" {}

resource "aws_vpc" "redshift-serverless-vpc" {
  cidr_block           = var.redshift_serverless_vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-redshift-serverless-vpc"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "redshift-serverless-subnet-az1" {
  vpc_id            = aws_vpc.redshift-serverless-vpc.id
  cidr_block        = var.redshift_serverless_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-redshift-serverless-subnet-az1"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "redshift-serverless-subnet-az2" {
  vpc_id            = aws_vpc.redshift-serverless-vpc.id
  cidr_block        = var.redshift_serverless_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-redshift-serverless-subnet-az2"
    Environment = var.app_environment
  }
}
