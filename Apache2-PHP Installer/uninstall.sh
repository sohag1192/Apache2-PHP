#!/usr/bin/env bash
# Apache2 + PHP uninstaller for Ubuntu/Debian
# Author: Md. Sohag Rana (GitHub: Sohag1192)
# Purpose: Remove Apache2/PHP and clean up ip.php

set -euo pipefail

echo "[*] Stopping Apache2 service..."
sudo systemctl stop apache2 || true

echo "[*] Disabling Apache2 service..."
sudo systemctl disable apache2 || true

echo "[*] Removing Apache2 and PHP packages..."
sudo apt-get remove --purge -y apache2 php libapache2-mod-php
sudo apt-get autoremove -y
sudo apt-get clean

echo "[*] Removing Apache2 configuration directories..."
sudo rm -rf /etc/apache2

echo "[*] Done. Apache2 and PHP have been uninstalled."
