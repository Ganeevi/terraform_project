#!/bin/bash

#Clean up
rm -rf /tmp/package/*
sudo rm -rf /var/www/html/*

#Package details for both Amazon-linux-2 and Ubuntu
package1="httpd"
package2="apache2 wget unzip"

URL_httpd=https://www.free-css.com/assets/files/free-css-templates/download/page296/healet.zip
URL_apache=https://www.free-css.com/assets/files/free-css-templates/download/page296/oxer.zip

yum --help $> /dev/null

if [ $? -eq 0 ]
then
        echo "Installing Packages on Amazon Linux 2"
        yum update -y
        yum install -y $package1
        mkdir -p /tmp/package
        cd /tmp/package
        wget $URL_httpd
        unzip healet.zip
        sudo mv healet-html/* /var/www/html/
        systemctl restart httpd
else
        echo "Installing Packages on Ubuntu"
        apt update -y
        apt-get install -y $package2
        mkdir -p /tmp/package
        cd /tmp/package
        wget $URL_apache
        unzip oxer.zip
        sudo mv oxer-html/* /var/www/html/
        systemctl restart apache2
fi
