resource "aws_vpc" "myVPC" {
  tags       = { Name = "myVPC" }
  cidr_block = lookup(var.vpc_cidr, terraform.workspace, "10.0.0.0/16")
}

resource "aws_internet_gateway" "myIGW" {
  tags   = { Name = "myIGW" }
  vpc_id = aws_vpc.myVPC.id
}

resource "aws_subnet" "Public-Subnet-1" {
  tags                    = { Name = "Public-Subnet-1" }
  vpc_id                  = aws_vpc.myVPC.id
  availability_zone       = lookup(var.Public-Subnet-1, terraform.workspace, "ap-south-1a")
  map_public_ip_on_launch = true
  cidr_block              = lookup(var.subnet-1_cidr, terraform.workspace, "10.0.10.0/24")
}

resource "aws_subnet" "Public-Subnet-2" {
  tags                    = { Name = "Public-Subnet-2" }
  vpc_id                  = aws_vpc.myVPC.id
  availability_zone       = lookup(var.Public-Subnet-2, terraform.workspace, "ap-south-1b")
  map_public_ip_on_launch = true
  cidr_block              = lookup(var.subnet-2_cidr, terraform.workspace, "10.0.20.0/24")
}

resource "aws_route_table" "Public-RT" {
  tags   = { Name = "Public-RT" }
  vpc_id = aws_vpc.myVPC.id
  route {
    gateway_id = aws_internet_gateway.myIGW.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "public-rt-asso" {
  subnet_id      = aws_subnet.Public-Subnet-1.id
  route_table_id = aws_route_table.Public-RT.id
}

resource "aws_route_table_association" "public-rt-asso-2" {
  subnet_id      = aws_subnet.Public-Subnet-2.id
  route_table_id = aws_route_table.Public-RT.id
}

resource "aws_security_group" "ssh" {
  tags   = { Name = "SSH" }
  vpc_id = aws_vpc.myVPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Jenkins-SG" {
  tags   = { Name = "Jenkins-SG" }
  vpc_id = aws_vpc.myVPC.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Nexus-SG" {
  tags   = { Name = "Nexus-SG" }
  vpc_id = aws_vpc.myVPC.id
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Sonar-SG" {
  tags   = { Name = "Sonar-SG" }
  vpc_id = aws_vpc.myVPC.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "web-key" {
  tags       = { Name = "web-key" }
  public_key = file("scripts/id_rsa.pub")
}

resource "aws_ecr_repository" "this" {
  name = repository_name_yuy
}

resource "aws_s3_bucket" "myS3" {
  bucket = "practicing-jenkins-with-terraform" //change accordingly
}

resource "aws_dynamodb_table" "mytable" {
  name         = "terraform_lock1"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}