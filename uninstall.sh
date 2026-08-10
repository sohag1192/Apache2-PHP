#!/usr/bin/env bash
# Apache2 + PHP uninstall for Ubuntu/Debian
# Author: Md. Sohag Rana (GitHub: Sohag1192)

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use: sudo bash uninstall.sh)"
  exit 1
fi

echo "======================================"
echo "    Apache2 & PHP Uninstaller         "
echo "======================================"
echo ""

# 1. Backup Option
read -p "Do you want to backup your web files (/var/www/html) to a zip archive first? (y/n): " backup_choice
if [[ "$backup_choice" =~ ^[Yy]$ ]]; then
  echo "--- Installing zip utility (if not present) ---"
  apt-get install zip -y -qq
  
  # Creates a backup file with the current date and time in the /root directory
  BACKUP_FILE="/root/html_backup_$(date +%Y%m%d_%H%M%S).zip"
  echo "--- Creating backup at $BACKUP_FILE ---"
  zip -r "$BACKUP_FILE" /var/www/html
  echo "--- Backup complete! ---"
  echo ""
fi

# 2. Uninstall Process
echo "--- Stopping Apache2 service ---"
systemctl stop apache2

echo "--- Removing Apache2, PHP, and extensions ---"
# 'purge' removes the packages and their configuration files
apt-get purge apache2 apache2-utils apache2-bin apache2.2-common php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-zip -y

echo "--- Removing orphaned dependencies ---"
apt-get autoremove -y
apt-get clean

echo "--- Cleaning up residual configuration directories ---"
rm -rf /etc/apache2
rm -rf /etc/php
echo ""

# 3. Delete Option
read -p "Do you want to completely DELETE the /var/www/html directory now? (y/n): " delete_choice
if [[ "$delete_choice" =~ ^[Yy]$ ]]; then
  echo "--- Deleting /var/www/html ---"
  rm -rf /var/www/html
  echo "--- Directory deleted ---"
else
  echo "--- Note: Your files in /var/www/html were left untouched. ---"
fi

echo ""
echo "--- Uninstall Complete! ---"