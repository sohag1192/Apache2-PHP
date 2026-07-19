#!/bin/bash

# Exit immediately if a command fails
set -e

echo "======================================================"
echo " Starting Optimized NGINX & All Common PHP Modules Install"
echo "======================================================"

# 1. Update package lists
echo "Updating package repository..."
sudo apt-get update -y

# 2. Install NGINX
echo "Installing NGINX..."
sudo apt-get install -y nginx

# 3. Install PHP-FPM and EVERY Common/Essential Module
# Includes database drivers, caching engines, image libraries, and encryption tools
echo "Installing PHP-FPM and a comprehensive suite of modules..."
sudo apt-get install -y \
  php-fpm \
  php-mysql \
  php-pgsql \
  php-sqlite3 \
  php-cli \
  php-curl \
  php-gd \
  php-mbstring \
  php-xml \
  php-zip \
  php-bcmath \
  php-intl \
  php-opcache \
  php-redis \
  php-imagick \
  php-soap \
  php-curl \
  php-json \
  php-gmp

# 4. Dynamically detect the installed PHP version
PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
echo "Detected PHP Version: $PHP_VERSION"

# 5. Optimize NGINX for High Traffic (500k hit readiness)
echo "Optimizing NGINX network configurations..."
sudo sed -i 's/worker_connections 768;/worker_connections 4096;\n\tmulti_accept on;/g' /etc/nginx/nginx.conf
sudo sed -i 's/worker_connections 1024;/worker_connections 4096;\n\tmulti_accept on;/g' /etc/nginx/nginx.conf

# 6. Optimize PHP-FPM for heavy user loads
# Adjusts performance settings inside the PHP pool configuration
POOL_FILE="/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"
if [ -f "$POOL_FILE" ]; then
    echo "Tuning PHP-FPM pool architecture ($POOL_FILE)..."
    sudo sed -i 's/pm = dynamic/pm = ondemand/g' $POOL_FILE
    sudo sed -i 's/pm.max_children = 5/pm.max_children = 100/g' $POOL_FILE
    sudo sed -i 's/pm.start_servers = 2/pm.start_servers = 10/g' $POOL_FILE
    sudo sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = 5/g' $POOL_FILE
    sudo sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = 20/g' $POOL_FILE
fi

# 7. Enable OPcache for high performance (speeds up PHP processing by 3x)
INI_FILE="/etc/php/${PHP_VERSION}/fpm/php.ini"
if [ -f "$INI_FILE" ]; then
    echo "Enabling OPcache backend processing..."
    sudo sed -i 's/;opcache.enable=1/opcache.enable=1/g' $INI_FILE
    sudo sed -i 's/;opcache.memory_consumption=128/opcache.memory_consumption=256/g' $INI_FILE
    sudo sed -i 's/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=20000/g' $INI_FILE
fi

# 8. Verify configurations and restart services
echo "Verifying configs and starting services..."
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl restart php${PHP_VERSION}-fpm

sudo systemctl enable nginx
sudo systemctl enable php${PHP_VERSION}-fpm

# 9. Open Firewall Rules
echo "Setting up firewall permissions..."
sudo ufw allow 'Nginx HTTP' || echo "UFW firewall is inactive, moving on."

echo "======================================================"
echo " System Deployment Successful!"
echo " NGINX: Running on Port 80 (Optimized)"
echo " PHP-FPM ($PHP_VERSION): Running with all modules enabled"
echo " OPcache Engine: Activated"
echo "======================================================"
