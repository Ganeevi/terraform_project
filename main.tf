resource "aws_vpc" "myVPC" {
    tags = { Name = "myVPC" }
    cidr_block = lookup(var.vpc_cidr, terraform.workspace, "10.0.0.0/16")
}

resource "aws_internet_gateway" "myIGW" {
    tags = { Name = "myIGW" }
    vpc_id = aws_vpc.myVPC.id
}

resource "aws_subnet" "Public-Subnet-1" {
    tags = { Name = "Public-Subnet-1" }
    vpc_id = aws_vpc.myVPC.id
    availability_zone = lookup(var.Public-Subnet-1, terraform.workspace, "ap-south-1a")
    map_public_ip_on_launch = true
    cidr_block = lookup(var.subnet-1_cidr, terraform.workspace, "10.0.10.0/24")
}

resource "aws_subnet" "Public-Subnet-2" {
    tags = { Name = "Public-Subnet-2" }
    vpc_id = aws_vpc.myVPC.id
    availability_zone = lookup(var.Public-Subnet-2, terraform.workspace, "ap-south-1b")
    map_public_ip_on_launch = true
    cidr_block = lookup(var.subnet-2_cidr, terraform.workspace, "10.0.20.0/24")
}

resource "aws_route_table" "Public-RT" {
    tags = { Name = "Public-RT" }
    vpc_id = aws_vpc.myVPC.id
    route {
        gateway_id = aws_internet_gateway.myIGW.id
        cidr_block = "0.0.0.0/0"
    }
}

resource "aws_route_table_association" "public-rt-asso" {
    subnet_id = aws_subnet.Public-Subnet-1.id
    route_table_id = aws_route_table.Public-RT.id
}

resource "aws_route_table_association" "public-rt-asso-2" {
    subnet_id = aws_subnet.Public-Subnet-2.id
    route_table_id = aws_route_table.Public-RT.id
}

resource "aws_security_group" "ssh" {
    tags = { Name = "ssh-enabled" }
    vpc_id = aws_vpc.myVPC.id
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

resource "aws_security_group" "web-SG" {
    tags = { Name = "URL Access" }
    vpc_id = aws_vpc.myVPC.id
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

resource "aws_key_pair" "web-key" {
    tags = { Name = "web-key" }
    public_key = file("~/.ssh/id_rsa.pub")  
}

/*resource "aws_ecr_repository" "this" {
  name = repository_name_yuy
}

resource "aws_s3_bucket" "myS3" {
    bucket = "terraform-init-april-training"
}

resource "aws_dynamodb_table" "mytable" {
  name = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}*/

//Jenkins-Master
resource "aws_instance" "jenkins-master" {
    tags = { Name = "jenkins-master" }
    instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
    ami = lookup(var.ami_id, terraform.workspace, "ami-060f2cb962e997969")
    security_groups = [ aws_security_group.web-SG.id, aws_security_group.ssh.id ]
    subnet_id = aws_subnet.Public-Subnet-1.id
    key_name = aws_key_pair.web-key.id

    connection {
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file("~/.ssh/id_rsa")
    }

    provisioner "file" {
        source = "scripts/user_creation.sh"
        destination = "/home/ec2-user/user_creation.sh"
	}
	
	provisioner "file" {
        source = "scripts/jenkins-master.sh"
        destination = "/home/ec2-user/jenkins-master.sh"
    }

    provisioner "file" {
        source = "scripts/id_rsa.pub"
        destination = "/home/ec2-user/id_rsa.pub"
    }

    provisioner "file" {
        source = "scripts/id_rsa"
        destination = "/home/ec2-user/id_rsa"
    }

    provisioner "remote-exec" {
        inline = [
            // Installing required packages
            "sudo yum install dos2unix -y",
            
			// Changing Permissions
			"sudo dos2unix /home/ec2-user/user_creation.sh /home/ec2-user/jenkins-master.sh",
			"sudo chmod +x /home/ec2-user/user_creation.sh /home/ec2-user/jenkins-master.sh",
            
			// Execute both files one-by-one
			"sudo sh /home/ec2-user/user_creation.sh",
			"sudo sh /home/ec2-user/jenkins-master.sh"
        ]
    }
}

// Jenkins-Slave
resource "aws_instance" "jenkins-slave" {
    tags = { Name = "jenkins-slave" }
    instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
    ami = lookup(var.ami_id, terraform.workspace, "ami-060f2cb962e997969")
    security_groups = [ aws_security_group.web-SG.id, aws_security_group.ssh.id ]
    subnet_id = aws_subnet.Public-Subnet-2.id
    key_name = aws_key_pair.web-key.id

    connection {
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file("~/.ssh/id_rsa")
    }

    provisioner "file" {
        source = "scripts/user_creation.sh"
        destination = "/home/ec2-user/user_creation.sh"
	}
	
	provisioner "file" {
        source = "scripts/jenkins-slave.sh"
        destination = "/home/ec2-user/jenkins-slave.sh"
    }

    provisioner "file" {
        source = "scripts/id_rsa.pub"
        destination = "/home/ec2-user/id_rsa.pub"
    }

    provisioner "file" {
        source = "scripts/id_rsa"
        destination = "/home/ec2-user/id_rsa"
    }

    provisioner "remote-exec" {
        inline = [
            // Installing required packages
            "sudo yum install dos2unix -y",
            
			// Changing Permissions
			"sudo dos2unix /home/ec2-user/user_creation.sh /home/ec2-user/jenkins-slave.sh",
			"sudo chmod +x /home/ec2-user/user_creation.sh /home/ec2-user/jenkins-slave.sh",
            
			// Execute both files one-by-one
			"sudo sh /home/ec2-user/user_creation.sh",
			"sudo sh /home/ec2-user/jenkins-slave.sh"
        ]
    }
}

// Ansible-Controller-Machine
resource "aws_instance" "ansible-CM" {
    tags = { Name = "ansible-CM" }
    instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
    ami = lookup(var.ami_id, terraform.workspace, "ami-060f2cb962e997969")
    security_groups = [ aws_security_group.web-SG.id, aws_security_group.ssh.id ]
    subnet_id = aws_subnet.Public-Subnet-1.id
    key_name = aws_key_pair.web-key.id

    connection {
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file("~/.ssh/id_rsa")
    }

    provisioner "file" {
        source = "scripts/user_creation.sh"
        destination = "/home/ec2-user/user_creation.sh"
	}
	
	provisioner "file" {
        source = "scripts/ansible-CM.sh"
        destination = "/home/ec2-user/ansible-CM.sh"
    }

    provisioner "file" {
        source = "scripts/id_rsa.pub"
        destination = "/home/ec2-user/id_rsa.pub"
    }

    provisioner "file" {
        source = "scripts/id_rsa"
        destination = "/home/ec2-user/id_rsa"
    }

    provisioner "remote-exec" {
        inline = [
            // Installing required packages
            "sudo yum install dos2unix -y",
            
			// Changing Permissions
			"sudo dos2unix /home/ec2-user/user_creation.sh /home/ec2-user/ansible-CM.sh",
			"sudo chmod +x /home/ec2-user/user_creation.sh /home/ec2-user/ansible-CM.sh",
            
			// Execute both files one-by-one
			"sudo sh /home/ec2-user/user_creation.sh",
			"sudo sh /home/ec2-user/ansible-CM.sh"
        ]
    }
}

// Ansible Node
resource "aws_instance" "ansible-node" {
    tags = { Name = "ansible-node" }
    instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
    ami = lookup(var.ami_id, terraform.workspace, "ami-060f2cb962e997969")
    security_groups = [ aws_security_group.web-SG.id, aws_security_group.ssh.id ]
    subnet_id = aws_subnet.Public-Subnet-2.id
    key_name = aws_key_pair.web-key.id

    connection {
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file("~/.ssh/id_rsa")
    }

    provisioner "file" {
        source = "scripts/user_creation.sh"
        destination = "/home/ec2-user/user_creation.sh"
	}

    provisioner "file" {
        source = "scripts/id_rsa.pub"
        destination = "/home/ec2-user/id_rsa.pub"
    }

    provisioner "file" {
        source = "scripts/id_rsa"
        destination = "/home/ec2-user/id_rsa"
    }

    provisioner "remote-exec" {
        inline = [
            // Installing required packages
            "sudo yum install dos2unix -y",
            
			// Changing Permissions
			"sudo dos2unix /home/ec2-user/user_creation.sh /home/ec2-user/ansible-node.sh",
			"sudo chmod +x /home/ec2-user/user_creation.sh /home/ec2-user/ansible-node.sh",
            
			// Execute both files one-by-one
			"sudo sh /home/ec2-user/user_creation.sh",
			"sudo sh /home/ec2-user/ansible-node.sh",
            "sudo hostnamectl set-hostname ansible-node"
        ]
    }
}