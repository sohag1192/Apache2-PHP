#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package lists..."
sudo apt update -y

echo "Installing Nginx and a full suite of PHP extensions..."
sudo apt install -y nginx php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip php-intl php-bcmath php-soap

# Detect the installed PHP version 
PHP_VERSION=$(php -v | head -n 1 | awk '{print $2}' | cut -d. -f1,2)
echo "Detected PHP Version: $PHP_VERSION"

echo "Configuring Nginx default server block for PHP processing..."
# This overwrites the default Nginx config with a working PHP configuration
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    
    # Prioritize index.php
    index index.php index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    # Pass PHP scripts to FastCGI server
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php${PHP_VERSION}-fpm.sock;
    }

    # Deny access to .htaccess files
    location ~ /\.ht {
        deny all;
    }
}
EOF

echo "Testing Nginx configuration..."
sudo nginx -t

echo "Enabling and restarting services..."
sudo systemctl enable nginx
sudo systemctl restart nginx

sudo systemctl enable php$PHP_VERSION-fpm
sudo systemctl restart php$PHP_VERSION-fpm

echo "Creating info.php test file..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php > /dev/null
sudo chown -R www-data:www-data /var/www/html/

echo "======================================"
echo "Installation and Configuration complete!"
echo "Nginx and PHP-FPM ($PHP_VERSION) are active and linked."
echo ""
echo "Test it by visiting: http://YOUR_SERVER_IP/info.php"
echo "======================================"