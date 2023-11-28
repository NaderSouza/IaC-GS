#!/bin/bash
yum update -y
amazon-linux-extras install -y php7.2 epel
yum install -y httpd telnet tree git

cd /tmp
git clone https://github.com/NaderSouza/IaC-GS
mkdir /var/www/html
cp /tmp/IaC-GS/app/*.html /var/www/html

systemctl enable httpd
service httpd restart
