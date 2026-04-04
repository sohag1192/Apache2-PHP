#!/bin/bash
# Apache2 + PHP Full Installation Script for Ubuntu
# Tested on Ubuntu 20.04/22.04

# Update system packages
sudo apt update -y
sudo apt upgrade -y

# Install Apache2
sudo apt install apache2 -y

# Enable Apache2 service
sudo systemctl enable apache2
sudo systemctl start apache2

# Install PHP and common extensions
sudo apt install php libapache2-mod-php php-cli php-mysql php-curl php-gd php-mbstring php-xml php-zip -y

# Configure Apache to prioritize PHP files
sudo sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf

# Allow .htaccess overrides
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Enable Apache rewrite module
sudo a2enmod rewrite

# Restart Apache to apply changes
sudo systemctl restart apache2

# Set permissions for web root
sudo chown -R $USER:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Create a PHP test file
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

echo "✅ Apache2 + PHP installation complete!"
echo "Visit http://localhost/info.php to verify PHP is working."
