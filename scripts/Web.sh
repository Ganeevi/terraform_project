#!/bin/bash

package1=httpd
package2="apache2 wget unzip"
package3=apache2

URL1=https://www.free-css.com/assets/files/free-css-templates/download/page296/healet.zip
URL2=https://www.free-css.com/assets/files/free-css-templates/download/page296/oxer.zip

sudo rm -rf /tmp/package/*
sudo rm -rf /var/www/html/*

yum --help

if [ $? -eq 0 ]
then
        echo "Installing 'Web-Server' on Amazon Linux 2"
        sudo yum update
        yum install -y $package1
        systemctl start $package1
        mkdir -p /tmp/package
        cd /tmp/package
        wget $URL1
        unzip healet.zip
        sudo mv healet-html/* /var/www/html/
        systemctl restart $package1
else
        echo "Installing 'Apache 2' on Ubuntu"
        apt update
        apt-get install -y $package2
        systemctl start $package3
        mkdir -p /tmp/package
        cd /tmp/package
        wget $URL2
        unzip oxer.zip
        sudo mv oxer-html/* /var/www/html/
        systemctl restart $package3
fi