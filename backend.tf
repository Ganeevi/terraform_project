terraform {
  backend "s3" {
    bucket         = "terraform-backend-1466"
    region         = "us-east-1"
    key            = "raman/terraform.tfstate"
    dynamodb_table = "terraform_lock1"
  }
}
