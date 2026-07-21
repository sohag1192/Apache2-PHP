#!/usr/bin/env bash
# The Ultimate Nginx & PHP-FPM Setup for 30k Hits
# Installs packages and optimizes for high concurrency

set -euo pipefail

echo "[*] Updating and installing Nginx + PHP..."
sudo apt-get update -y
sudo apt-get install -y nginx php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip php-intl php-bcmath

# Detect PHP version
PHP_VERSION=$(php -v | head -n 1 | awk '{print $2}' | cut -d. -f1,2)
echo "[*] Detected PHP Version: $PHP_VERSION"

echo "[*] Writing optimized nginx.conf for high traffic..."
sudo tee /etc/nginx/nginx.conf > /dev/null << 'EOF'
user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 4096;
    multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 2048;
    server_tokens off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/access.log;

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

echo "[*] Configuring default Nginx server block..."
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    index index.php index.html index.htm;
    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php${PHP_VERSION}-fpm.sock;
        
        # Prevent 504 Gateway Timeouts under heavy load
        fastcgi_read_timeout 120s;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 256 16k;
        fastcgi_busy_buffers_size 256k;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

echo "[*] Tuning PHP-FPM limits for 30,000 hits..."
PHP_FPM_CONF="/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"
if [ -f "$PHP_FPM_CONF" ]; then
    # 100 children is optimal for ~5GB of dedicated PHP RAM
    sudo sed -i 's/^pm = .*/pm = dynamic/' "$PHP_FPM_CONF"
    sudo sed -i 's/^pm.max_children = .*/pm.max_children = 100/' "$PHP_FPM_CONF"
    sudo sed -i 's/^pm.start_servers = .*/pm.start_servers = 20/' "$PHP_FPM_CONF"
    sudo sed -i 's/^pm.min_spare_servers = .*/pm.min_spare_servers = 15/' "$PHP_FPM_CONF"
    sudo sed -i 's/^pm.max_spare_servers = .*/pm.max_spare_servers = 30/' "$PHP_FPM_CONF"
    sudo sed -i 's/^;pm.max_requests = .*/pm.max_requests = 500/' "$PHP_FPM_CONF"
fi

echo "[*] Increasing OS file descriptor limits..."
LIMITS_CONF="/etc/security/limits.conf"
if ! grep -q "nginx   soft    nofile" "$LIMITS_CONF"; then
    echo "nginx   soft    nofile  65535" | sudo tee -a "$LIMITS_CONF" > /dev/null
    echo "nginx   hard    nofile  65535" | sudo tee -a "$LIMITS_CONF" > /dev/null
fi

echo "[*] Testing Nginx and restarting services..."
sudo nginx -t
sudo systemctl restart "php${PHP_VERSION}-fpm"
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full' || true

echo "======================================================="
echo "Success! Nginx and PHP-$PHP_VERSION are fully optimized."
echo "Your server is now configured for 30k massive traffic."
echo "======================================================="