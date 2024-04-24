#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install java-17-amazon-corretto-devel -y
sudo echo "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64" >> /etc/profile
sudo echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile
source /etc/profile
echo $JAVA_HOME
java --version
sudo sed -i 's\#PasswordAuthentication yes\PasswordAuthentication yes\g' /etc/ssh/sshd_config
sudo sed -i 's\PasswordAuthentication no\#PasswordAuthentication no\g' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo yum install -y git
sudo hostnamectl set-hostname jenkins-slave