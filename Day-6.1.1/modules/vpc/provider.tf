/*variable "aws_region" {
    description = "value"
    type = map(string)

    default = {
      "dev" = "ap-south-1"
      "stage" = "us-east-1"
      "prod" = "ap-northeast-1"
    }
}*/


provider "aws" {
    region = "ap-south-1"
}