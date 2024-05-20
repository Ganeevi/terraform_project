variable "aws_region" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "ap-south-1"
    //"stage" = "ap-northeast-1"
    "dev" = "us-east-1"
  }
}

variable "vpc_cidr" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "10.0.0.0/16"
    //"stage" = "172.16.0.0/16"
    "dev" = "192.168.0.0/16"
  }
}

variable "Public-Subnet-1" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "ap-south-1a"
    //"stage" = "ap-northeast-1a"
    "dev" = "us-east-1a"
  }
}

variable "Public-Subnet-2" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "ap-south-1b"
    //"stage" = "ap-northeast-1c"
    "dev" = "us-east-1b"
  }
}

variable "Public-subnet-1_cidr" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "10.0.10.0/24"
    //"stage" = "172.16.10.0/24"
    "dev" = "192.168.10.0/24"
  }
}

variable "Public-subnet-2_cidr" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "10.0.20.0/24"
    //"stage" = "172.16.20.0/24"
    "dev" = "192.168.20.0/24"
  }
}

variable "Private-Subnet-1" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "ap-south-1a"
    //"stage" = "ap-northeast-1a"
    "dev" = "us-east-1a"
  }
}

variable "Private-Subnet-2" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "ap-south-1b"
    //"stage" = "ap-northeast-1c"
    "dev" = "us-east-1b"
  }
}

variable "Private-subnet-1_cidr" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "10.0.30.0/24"
    //"stage" = "172.16.30.0/24"
    "dev" = "192.168.30.0/24"
  }
}

variable "Private-subnet-2_cidr" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "10.0.40.0/24"
    //"stage" = "172.16.40.0/24"
    "dev" = "192.168.40.0/24"
  }
}

variable "instance_type" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "t2.medium"
    //"stage" = "t2.medium"
    "dev" = "t2.micro"
  }
}

variable "instance_sonarqube" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "t2.medium"
    //"stage" = "t2.medium"
    "dev" = "t2.medium"
  }
}

variable "ami_id_amazon-linux-2" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "ami-060f2cb962e997969"
    //"stage" = "ami-04e0b6d6cfa432943"
    "dev" = "ami-04ff98ccbfa41c9ad"
  }
}

variable "ami_ubuntu" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = "ami-05e00961530ae1b55"
    //"stage" = "ami-0595d6e81396a9efb"
    "dev" = "ami-0e001c9271cf7f3b9"
  }
}

variable "key_name" {
  description = "value"
  type        = map(string)
  default = {
    //"dev"   = ""
    //"stage" = ""
    "dev" = "America"
  }
}