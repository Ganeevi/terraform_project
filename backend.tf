terraform {
  backend "s3" {
    bucket = "grewall-s3-demo-xyz"
    region = "ap-south-1"
    key = "raman/terraform.tfstate"
    dynamodb_table = "terraform_lock"
  }
}
