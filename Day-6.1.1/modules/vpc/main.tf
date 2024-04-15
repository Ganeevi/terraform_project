resource "aws_vpc" "myVPC" {
    cidr_block = var.vpc_cidr
    tags = { Name = "MyVPC" }
}

resource "aws_internet_gateway" "myIGW" {
    vpc_id = aws_vpc.myVPC.id
    tags = { Name = "myIGW" }  
}

resource "aws_subnet" "Public-Subnet-1a" {
    vpc_id = aws_vpc.myVPC.id
    tags = { Name = "Public-Subnet-1a" }
    cidr_block = var.cidr-public-subnet-1a
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
}

resource "aws_route_table" "Public-RT" {
    vpc_id = aws_vpc.myVPC.id
    tags = { Name = "Public-RT" }
    route {
        gateway_id = aws_internet_gateway.myIGW.id
        cidr_block = "0.0.0.0/0"
    }
}

resource "aws_route_table_association" "Public-RT-Asso" {
    route_table_id = aws_route_table.Public-RT.id
    subnet_id = aws_subnet.Public-Subnet-1a.id
}

resource "aws_security_group" "Web-SG" {
    vpc_id = aws_vpc.myVPC.id
    tags = { Name = "Public-Web-SG" }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
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
