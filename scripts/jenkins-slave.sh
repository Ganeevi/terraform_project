#!/bin/bash
sudo yum update -y
sudo yum install java-17-amazon-corretto-devel -y
sudo echo "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64" >> /etc/profile
sudo echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile
source /etc/profile
echo $JAVA_HOME
java --version
sudo yum install -y git
sudo hostnamectl set-hostname jenkins-slave