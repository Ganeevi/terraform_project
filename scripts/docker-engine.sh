#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
sed -i 's\#PasswordAuthentication yes\PasswordAuthentication yes\g' /etc/ssh/sshd_config
sed -i 's\PasswordAuthentication no\#PasswordAuthentication no\g' /etc/ssh/sshd_config
systemctl restart sshd
hostnamectl set-hostname docker-enginer