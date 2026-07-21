#!/usr/bin/env bash
# Nginx + PHP uninstaller for Ubuntu/Debian
# Author: Md. Sohag Rana (GitHub: Sohag1192)
# Purpose: Remove Nginx/PHP and clean up ip.php

set -euo pipefail

echo "[*] Stopping Nginx service..."
sudo systemctl stop nginx || true

echo "[*] Disabling Nginx service..."
sudo systemctl disable nginx || true

echo "[*] Removing Nginx and PHP packages..."
sudo apt-get remove --purge -y nginx php php-fpm
sudo apt-get autoremove -y
sudo apt-get clean


echo "[*] Removing Nginx configuration directories..."
sudo rm -rf /etc/nginx

echo "[*] Done. Nginx and PHP have been uninstalled."