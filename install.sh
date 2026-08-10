#!/usr/bin/env bash
# Apache2 + PHP install for Ubuntu/Debian
# Author: Md. Sohag Rana (GitHub: Sohag1192)

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use: sudo bash setup.sh)"
  exit 1
fi

echo "--- Updating package lists ---"
apt-get update -y

echo "--- Installing Apache2 ---"
apt-get install apache2 -y

echo "--- Installing PHP and common extensions ---"
apt-get install php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-zip -y

echo "--- Enabling Apache mod_rewrite ---"
a2enmod rewrite

echo "--- Configuring 000-default.conf ---"
# Injects the Directory block to allow .htaccess overrides
sed -i 's|<\/VirtualHost>|\t<Directory /var/www/html>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tRequire all granted\n\t</Directory>\n</VirtualHost>|' /etc/apache2/sites-available/000-default.conf

echo "--- Setting secure ownership and permissions ---"
# Make the Apache user the owner of the web directory
chown -R www-data:www-data /var/www/html

# Set directories to 755 (Owner can write, others can read/execute)
find /var/www/html -type d -exec chmod 755 {} \;

# Set files to 644 (Owner can write, others can read)
find /var/www/html -type f -exec chmod 644 {} \;

echo "--- Restarting Apache to apply all changes ---"
systemctl restart apache2

echo "--- Setup Complete! ---"