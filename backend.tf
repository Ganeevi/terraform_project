terraform {
  backend "s3" {
    bucket = "terraform-init-april-training"
    region = "ap-south-1"
    key = "raman/terraform.tfstate"
    dynamodb_table = "terraform_lock"
  }
}