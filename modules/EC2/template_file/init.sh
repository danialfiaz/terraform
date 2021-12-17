#!/bin/bash
 echo "just to see"
 sudo yum update -y

 sudo yum install -y php56
 sudo yum install php56-mysqlnd
 echo "httpd"
 sudo yum install -y httpd
 sudo systemctl start httpd
 sudo systemctl enable httpd
 sudo usermod -a -G apache ec2-user
 sudo chown -R ec2-user:apache /var/www
 sudo chmod 2775 /var/www
 find /var/www -type d -exec sudo chmod 2775 {} \;
 find /var/www -type f -exec sudo chmod 0664 {} \;
 cd /var/www
 mkdir inc
 cd inc
 sudo echo  "<?php
 define('DB_SERVER', '${rds_endpoint}');
 define('DB_USERNAME', '${username_wp}');
 define('DB_PASSWORD', '${password_wp}');
 define('DB_DATABASE', '${name_wp}');
 ?>"  > dbinfo.inc
 sudo aws s3 cp s3://danial96/Samplepage.php /var/www/html/Samplepage.php


 wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
 sudo yum localinstall mysql57-community-release-el7-8.noarch.rpm -y
 sudo yum install mysql-community-server -y
 sudo systemctl start mysqld

 sudo service httpd restart