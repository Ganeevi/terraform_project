/*resource "aws_ebs_volume" "ebs-1a" {
  tags              = { Name = "ebs-1a" }
  availability_zone = lookup(var.Public-Subnet-1, terraform.workspace, "ap-south-1a")
  size              = 10
}

resource "aws_ebs_volume" "ebs-1b" {
  tags              = { Name = "ebs-1b" }
  availability_zone = lookup(var.Public-Subnet-2, terraform.workspace, "ap-south-1b")
  size              = 10
}

resource "aws_volume_attachment" "attach-ebs-1a" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-1a.id
  instance_id = aws_instance.jenkins-master.id
}

resource "aws_volume_attachment" "attach-ebs-1b" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-1b.id
  instance_id = aws_instance.jenkins-slave.id
}

//Jenkins-Master
resource "aws_instance" "jenkins-master" {
  tags                        = { Name = "Jenkins-Master" }
  instance_type               = lookup(var.instance_type, terraform.workspace, "t2.medium")
  ami                         = lookup(var.ami_id_amazon-linux-2, terraform.workspace, "ami-060f2cb962e997969")
  security_groups             = [aws_security_group.Jenkins-SG.id, aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.Public-Subnet-1.id
  user_data                   = file("scripts/jenkins-master.sh")
  user_data_replace_on_change = "true"
  key_name                    = "Mumbai"
  //iam_instance_profile      = aws_iam_instance_profile.ec2_profile.id
}

// Jenkins-Slave
resource "aws_instance" "jenkins-slave" {
  tags                        = { Name = "Jenkins-Slave" }
  instance_type               = lookup(var.instance_type, terraform.workspace, "t2.micro")
  ami                         = lookup(var.ami_id_amazon-linux-2, terraform.workspace, "ami-060f2cb962e997969")
  security_groups             = [aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.Public-Subnet-2.id
  key_name                    = "Mumbai"
  user_data                   = file("scripts/jenkins-slave.sh")
  user_data_replace_on_change = "true"
  //iam_instance_profile      = aws_iam_instance_profile.ec2_profile.id
}

// Nexus Server setup - hardcoded few properties need to change
resource "aws_instance" "Nexus-Server" {
  tags                        = { Name = "Nexus-Server" }
  instance_type               = lookup(var.instance_type, terraform.workspace, "t2.medium")
  ami                         = lookup(var.ami_id_amazon-linux-2, terraform.workspace, "ami-060f2cb962e997969")
  security_groups             = [aws_security_group.ssh.id, aws_security_group.Nexus-SG.id]
  subnet_id                   = aws_subnet.Public-Subnet-2.id
  user_data                   = file("scripts/nexus-setup.sh")
  user_data_replace_on_change = "true"
  key_name                    = "Mumbai"
}

// Sonar Server setup - hardcoded few properties need to change
resource "aws_instance" "Sonar-Server" {
  tags                        = { Name = "Sonar-Server" }
  instance_type               = lookup(var.instance_sonarqube, terraform.workspace, "t2.medium")
  ami                         = lookup(var.ami_ubuntu, terraform.workspace, "ami-05e00961530ae1b55") // Ubuntu 22
  security_groups             = [aws_security_group.ssh.id, aws_security_group.Sonar-SG.id]
  subnet_id                   = aws_subnet.Public-Subnet-2.id
  user_data                   = file("scripts/sonar-setup.sh")
  user_data_replace_on_change = "true"
  key_name                    = "Mumbai"
}

// Ansible-Controller-Machine
resource "aws_instance" "ansible-CM" {
  tags                        = { Name = "Ansible-CM" }
  instance_type               = lookup(var.instance_type, terraform.workspace, "t2.micro")
  ami                         = lookup(var.ami_id_amazon-linux-2, terraform.workspace, "ami-060f2cb962e997969")
  security_groups             = [aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.Public-Subnet-1.id
  user_data                   = file("scripts/ansible-CM.sh")
  user_data_replace_on_change = "true"
  key_name                    = "Mumbai"
}

// Ansible Node
resource "aws_instance" "ansible-node" {
  tags                        = { Name = "Ansible-Node" }
  //count                     = 3
  instance_type               = lookup(var.instance_type, terraform.workspace, "t2.micro")
  ami                         = lookup(var.ami_id_amazon-linux-2, terraform.workspace, "ami-060f2cb962e997969")
  security_groups             = [aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.Public-Subnet-2.id
  user_data                   = file("scripts/ansible-node.sh")
  user_data_replace_on_change = "true"
  key_name                    = "Mumbai"
}*/

// Docker-Engine
resource "aws_instance" "docker-enginer" {
  tags                        = { Name = "Docker" }
  instance_type               = lookup(var.instance_type, terraform.workspace, "t2.micro")
  ami                         = lookup(var.ami_id_amazon-linux-2, terraform.workspace, "ami-060f2cb962e997969")
  security_groups             = [aws_security_group.All-Open.id]
  subnet_id                   = aws_subnet.Public-Subnet-2.id
  key_name                    = "Mumbai"
  user_data                   = file("scripts/docker-engine.sh")
  user_data_replace_on_change = "true"
}