#!/bin/bash
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install java-17-amazon-corretto-devel -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo echo "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64" >> /etc/profile
sudo echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile
source /etc/profile
echo $JAVA_HOME
java --version
sudo yum install -y git
sudo hostnamectl set-hostname jenkins-master