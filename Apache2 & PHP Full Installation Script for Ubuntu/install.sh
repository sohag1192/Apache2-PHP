#!/bin/bash
# Apache2 + PHP Full Installation Script for Ubuntu
# Author: Md. Sohag Rana (Sarker Net)

set -e

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing Apache2..."
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

echo "Installing PHP with common modules..."
sudo apt install php libapache2-mod-php php-cli php-common \
php-mysql php-curl php-gd php-mbstring php-xml php-zip -y

echo "Configuring Apache to allow all files..."
APACHE_CONF="/etc/apache2/apache2.conf"
sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/c\<Directory /var/www/>\n    Options Indexes FollowSymLinks\n    AllowOverride All\n    Require all granted\n</Directory>' $APACHE_CONF

echo "Enabling mod_rewrite..."
sudo a2enmod rewrite

echo "Restarting Apache..."
sudo systemctl restart apache2

echo "Creating PHP test file..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php > /dev/null

echo "Installation complete!"
echo "Visit http://your_server_ip/info.php to verify PHP integration."