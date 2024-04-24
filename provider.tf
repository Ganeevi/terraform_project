provider "aws" {
  region = lookup(var.aws_region, terraform.workspace, "ap-south-1")
}
