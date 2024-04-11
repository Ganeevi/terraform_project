variable "vpc_cidr" {
    //default =  "10.0.0.0/16"
}

variable "AMI_id" {
    //default = "ami-0451f2687182e0411"
}

variable "subnet_cidr-1a" {
    //default =  "10.0.10.0/24"
}

variable "AZ-1a" {
    //default = "ap-south-1a"
}

variable "subnet_cidr-1b" {
    //default =  "10.0.20.0/24"
}

variable "AZ-1b" {
    //default = "ap-south-1b"
}

variable "instance_type-Jenkins" {
    //default = "t2.micro"
}

variable "instance_type-jfrog" {
    //default = "t2.medium"
}

variable "repository_name" {
  //description = "The name of the repository"
  //type        = string
  //default     = "myrepo"
}

variable "repository_type" {
  description = "The type of repository to create. Either `public` or `private`"
  type        = string
  default     = "private"
}