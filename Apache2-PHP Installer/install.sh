#!/usr/bin/env bash
# Apache2 + PHP installer and IP viewer deployer
# Author: Md. Sohag Rana (GitHub: Sohag1192)
# Purpose: Install Apache2/PHP and create ip.php to show client/server IPs

set -euo pipefail

echo "[*] Updating package lists..."
sudo apt-get update -y

echo "[*] Installing Apache2 and PHP..."
sudo apt-get install -y apache2 php libapache2-mod-php

echo "[*] Enabling and starting Apache2..."
sudo systemctl enable apache2
sudo systemctl restart apache2

echo "[*] Deploying ip.php to /var/www/html/"
sudo tee /var/www/html/ip.php > /dev/null <<'PHP'
<?php
function getClientIp(): string {
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ips = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
        return trim($ips[0]);
    }
    if (!empty($_SERVER['HTTP_X_REAL_IP'])) {
        return $_SERVER['HTTP_X_REAL_IP'];
    }
    return $_SERVER['REMOTE_ADDR'] ?? 'unknown';
}

$clientIp   = getClientIp();
$remoteAddr = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$serverIp   = $_SERVER['SERVER_ADDR'] ?? 'unknown';

header('Content-Type: text/plain');
echo "Client IP (best guess): $clientIp\n";
echo "Remote addr (Apache sees): $remoteAddr\n";
echo "Server IP: $serverIp\n";
echo "Forwarded for: " . ($_SERVER['HTTP_X_FORWARDED_FOR'] ?? 'n/a') . "\n";
echo "Real IP header: " . ($_SERVER['HTTP_X_REAL_IP'] ?? 'n/a') . "\n";
PHP

echo "[*] Done! Test it with: curl http://<your-server-ip>/ip.php"
