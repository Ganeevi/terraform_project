provider "aws" {
  region = lookup(var.aws_region, terraform.workspace, "us-east-1")
}
