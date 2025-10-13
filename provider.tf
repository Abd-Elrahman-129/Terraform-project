terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "terraform"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr_block
}

#create subnets resource
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.example.id
  cidr_block = var.subnets.subnet1.cidr_block
  availability_zone = var.subnets.subnet1.az
}
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.example.id
  cidr_block = var.subnets.subnet2.cidr_block
  availability_zone = var.subnets.subnet2.az
}

#create IGW resource
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.example.id
}

#create route table resource
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  # route {
  #   cidr_block = var.subnets.subnet1.cidr_block
  #   gateway_id = aws_internet_gateway.tf-igw.id
  # }

  # route {
  #   cidr_block = var.subnets.subnet2.cidr_block
  #   gateway_id = aws_internet_gateway.tf-igw.id
  # }

  tags = {
    Name = "example"
  }
}
