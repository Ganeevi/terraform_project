provider "aws" {
    region = "ap-south-1"
}

variable "ami" {
    description = "value"
}

variable "instance_type" {
    description = "value"
    type = map(string)

    default = {
      "dev" = "t2.micro"
      "stage" = "t2.medium"
      "prod" = "t2.xlarge"
    }
}

variable "vpc_cidr" {
    description = "VPC_CIDR"
    type = map(string)

    default = {
      "dev" = "10.0.0.0/16"
      "stage" = "192.168.0.0/16"
      "prod" = "172.16.0.0/16"
    }
}

variable "cidr-public-subnet-1a" {
    description = "value"
    type = map(string)

    default = {
      "dev" = "10.0.10.0/24"
      "stage" = "192.168.10.0/24"
      "prod" = "172.16.10.0/24"
    }

}

variable "AZ-1a" {
    description = "value"
    //default = "ap-south-1a"
}

module "ec2-instance" {
    source = "./modules/ec2-instances"
    ami = var.ami
    instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}

module "aws_vpc" {
    source = "./modules/vpc"
    vpc_cidr = lookup(var.vpc_cidr, terraform.workspace, "10.0.0.0/0")
    cidr-public-subnet-1a = lookup(var.cidr-public-subnet-1a, terraform.workspace, "10.0.10.0/24")
}