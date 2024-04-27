#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo yum install -y ansible
ansible --version
sudo hostnamectl set-hostname Ansible-Master