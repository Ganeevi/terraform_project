resource "aws_vpc" "myVPC" {
  tags                 = { Name = "myVPC" }
  cidr_block           = lookup(var.vpc_cidr, terraform.workspace, "192.168.0.0/16")
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "myIGW" {
  tags   = { Name = "myIGW" }
  vpc_id = aws_vpc.myVPC.id
}

// Public Subnet
resource "aws_subnet" "Public-Subnet-1" {
  tags                    = { Name = "Public-Subnet-1" }
  vpc_id                  = aws_vpc.myVPC.id
  availability_zone       = lookup(var.Public-Subnet-1, terraform.workspace, "us-east-1a")
  map_public_ip_on_launch = true
  cidr_block              = lookup(var.Public-subnet-1_cidr, terraform.workspace, "192.168.10.0/24")
}

resource "aws_subnet" "Public-Subnet-2" {
  tags                    = { Name = "Public-Subnet-2" }
  vpc_id                  = aws_vpc.myVPC.id
  availability_zone       = lookup(var.Public-Subnet-2, terraform.workspace, "us-east-1b")
  map_public_ip_on_launch = true
  cidr_block              = lookup(var.Public-subnet-2_cidr, terraform.workspace, "192.168.20.0/24")
}

resource "aws_route_table" "Public-RT" {
  tags   = { Name = "Public-RT" }
  vpc_id = aws_vpc.myVPC.id
  route {
    gateway_id = aws_internet_gateway.myIGW.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "public-rt-asso-1" {
  subnet_id      = aws_subnet.Public-Subnet-1.id
  route_table_id = aws_route_table.Public-RT.id
}

resource "aws_route_table_association" "public-rt-asso-2" {
  subnet_id      = aws_subnet.Public-Subnet-2.id
  route_table_id = aws_route_table.Public-RT.id
}

// Private Subnet
/*resource "aws_subnet" "Private-Subnet-1" {
  tags                    = { Name = "Private-Subnet-1" }
  vpc_id                  = aws_vpc.myVPC.id
  availability_zone       = lookup(var.Private-Subnet-1, terraform.workspace, "us-east-1a")
  map_public_ip_on_launch = false
  cidr_block              = lookup(var.Private-subnet-1_cidr, terraform.workspace, "192.168.30.0/24")
}

resource "aws_subnet" "Private-Subnet-2" {
  tags                    = { Name = "Private-Subnet-2" }
  vpc_id                  = aws_vpc.myVPC.id
  availability_zone       = lookup(var.Private-Subnet-2, terraform.workspace, "us-east-1b")
  cidr_block              = lookup(var.Private-subnet-2_cidr, terraform.workspace, "192.168.40.0/24")
  map_public_ip_on_launch = false
}

resource "aws_eip" "myEIP" {
  tags = { Name = "myEIP" }
}

resource "aws_nat_gateway" "myNAT" {
  tags          = { Name = "myNAT" }
  allocation_id = aws_eip.myEIP.id
  subnet_id     = aws_subnet.Public-Subnet-1.id
}

resource "aws_route_table" "Private-RT" {
  tags   = { Name = "Private-RT" }
  vpc_id = aws_vpc.myVPC.id
  route {
    nat_gateway_id = aws_nat_gateway.myNAT.id
    cidr_block     = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "Private-rt-asso-1" {
  subnet_id      = aws_subnet.Private-Subnet-1.id
  route_table_id = aws_route_table.Private-RT.id
}

resource "aws_route_table_association" "Private-rt-asso-2" {
  subnet_id      = aws_subnet.Private-Subnet-2.id
  route_table_id = aws_route_table.Private-RT.id
}*/

// Security Groups
resource "aws_security_group" "ssh" {
  tags   = { Name = "SSH" }
  name   = "SSH - terraform"
  vpc_id = aws_vpc.myVPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.207.52.76/32"]
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
  name   = "Jenkins-SG - terraform"
  vpc_id = aws_vpc.myVPC.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["49.207.52.76/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["49.207.52.76/32"]
  }
}

resource "aws_security_group" "Nexus-SG" {
  tags   = { Name = "Nexus-SG" }
  name   = "Nexus-SG - terraform"
  vpc_id = aws_vpc.myVPC.id
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["49.207.52.76/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Web" {
  tags   = { Name = "Web" }
  name   = "Web - terraform"
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

resource "aws_security_group" "All-Open" {
  tags   = { Name = "All-Open" }
  name   = "All-Open - terraform"
  vpc_id = aws_vpc.myVPC.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["49.207.52.76/32"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.207.52.76/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*resource "aws_key_pair" "web-key" {
  tags       = { Name = "web-key" }
  public_key = file("scripts/id_rsa.pub")
}

resource "aws_ecr_repository" "this" {
  name = repository_name_yuy
}

resource "aws_s3_bucket" "myS3" {
  bucket = "terraform-backend-1466" //change accordingly
}

resource "aws_dynamodb_table" "mytable" {
  name         = "terraform_lock1"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}*/