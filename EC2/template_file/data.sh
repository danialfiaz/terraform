
sudo yum update -y
sudo yum install -y httpd
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
#ls
#latest.tar.gz  wordpress
cd wordpress
cp wp-config-sample.php wp-config.php
define('DB_SERVER', '${rds_endpoint}');
define('DB_USERNAME', '${username_wp}');
define('DB_PASSWORD', '${password_wp;}');
define('DB_DATABASE', '${name_wp}');
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
cd /home/ec2-user
sudo cp -r wordpress/* /var/www/html/
sudo service httpd restart