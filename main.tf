resource "aws_ecr_repository" "this" {
  name = var.repository_name
}

resource "aws_vpc" "myVPC" {
    cidr_block = var.vpc_cidr
    tags = { Name = "myVPC" }  
}

resource "aws_internet_gateway" "myIGW" {
    vpc_id = aws_vpc.myVPC.id
    tags = { Name = "myIGW"}
}

resource "aws_subnet" "Public-Subnet-1a" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.subnet_cidr-1a
    availability_zone = var.AZ-1a
    tags = { Name = "Public-Subnet-1a"}
}

resource "aws_subnet" "Public-Subnet-1b" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.subnet_cidr-1b
    availability_zone = var.AZ-1b
    tags = { Name = "Public-Subnet-1b"}
}

resource "aws_route_table" "myPublic_RT" {
    tags = { Name = "Public-RT"}
    vpc_id = aws_vpc.myVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIGW.id
    }
}

resource "aws_route_table_association" "Public-RT-Asso-1a" {
    route_table_id = aws_route_table.myPublic_RT.id
    subnet_id = aws_subnet.Public-Subnet-1a.id
}

resource "aws_route_table_association" "Public-RT-Asso-1b" {
    route_table_id = aws_route_table.myPublic_RT.id
    subnet_id = aws_subnet.Public-Subnet-1b.id
}

resource "aws_security_group" "Web-SG" {
    vpc_id = aws_vpc.myVPC.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

/*resource "aws_s3_bucket" "myS3" {
    bucket = "terraform-init-april-training"
}*/

resource "aws_dynamodb_table" "mytable" {
  name = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_instance" "Master" {
        ami = var.AMI_id
        instance_type = var.instance_type-Jenkins
        key_name = "Mumbai"
        subnet_id = "${aws_subnet.Public-Subnet-1a.id}"
        vpc_security_group_ids = [ aws_security_group.Web-SG.id ]
        associate_public_ip_address = "true"
        tags = { Name = "Jenkins-Master" }
        user_data = "${file("package_script/package.sh")}"
        user_data_replace_on_change = "true"
}

resource "aws_instance" "Slave" {
        ami = var.AMI_id
        instance_type = var.instance_type-Jenkins
        key_name = "Mumbai"
        count = 2
        subnet_id = "${aws_subnet.Public-Subnet-1b.id}"
        vpc_security_group_ids = [ aws_security_group.Web-SG.id ]
        associate_public_ip_address = "true"
        tags = { Name = "Jenkins-Slave" }
        user_data = "${file("package_script/slave_package.sh")}"
        user_data_replace_on_change = "true"
}

resource "aws_instance" "jfrog-artifactory" {
        ami = var.AMI_id
        instance_type = var.instance_type-jfrog
        key_name = "Mumbai"
        count = 1
        subnet_id = "${aws_subnet.Public-Subnet-1b.id}"
        vpc_security_group_ids = [ aws_security_group.Web-SG.id ]
        associate_public_ip_address = "true"
        tags = { Name = "jfrog-artifactory" }
        user_data = "${file("package_script/jfrog.sh")}"
        user_data_replace_on_change = "true"
}

output "public_ip_Master" {
    value = aws_instance.Master.public_ip
}
output "private_ip_Master" {
    value = aws_instance.Master.private_ip
}

output "public_ip_Slave" {
    value = aws_instance.Slave.*.public_ip
}
output "private_ip_Slave" {
    value = aws_instance.Slave.*.private_ip
}
