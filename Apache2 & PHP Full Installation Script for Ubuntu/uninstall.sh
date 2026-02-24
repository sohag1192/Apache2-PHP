#!/bin/bash
# Uninstall Apache2 + PHP Script for Ubuntu
# Author: Md. Sohag Rana (Sarker Net)

set -e

echo "Stopping Apache2 service..."
sudo systemctl stop apache2 || true

echo "Disabling Apache2 service..."
sudo systemctl disable apache2 || true

echo "Removing Apache2 and PHP packages..."
sudo apt purge apache2 apache2-utils apache2-bin apache2.2-common -y
sudo apt purge php libapache2-mod-php php-cli php-common php-mysql \
php-curl php-gd php-mbstring php-xml php-zip -y

echo "Cleaning up unused dependencies..."
sudo apt autoremove -y
sudo apt autoclean -y

echo "Removing Apache2 and PHP configuration files..."
sudo rm -rf /etc/apache2
sudo rm -rf /etc/php

echo "Uninstallation complete!"