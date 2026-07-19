#!/bin/bash

# Exit immediately if a command fails
set -e

echo "========================================="
echo " Starting NGINX Installation"
echo "========================================="

# 1. Update package lists
echo "Updating package repository..."
sudo apt-get update -y

# 2. Install NGINX
echo "Installing NGINX..."
sudo apt-get install -y nginx

# 3. Optimize for High Traffic
# This increases worker_connections to allow more simultaneous users
# and enables multi_accept so workers accept all new connections at once.
echo "Optimizing NGINX for high user load..."
sudo sed -i 's/worker_connections 768;/worker_connections 4096;\n\tmulti_accept on;/g' /etc/nginx/nginx.conf
sudo sed -i 's/worker_connections 1024;/worker_connections 4096;\n\tmulti_accept on;/g' /etc/nginx/nginx.conf

# 4. Test configuration and restart
echo "Testing NGINX configuration..."
sudo nginx -t

echo "Enabling and starting NGINX..."
sudo systemctl enable nginx
sudo systemctl restart nginx

# 5. Open Firewall (if UFW is active)
echo "Configuring firewall for HTTP (Port 80)..."
sudo ufw allow 'Nginx HTTP' || echo "UFW not active, skipping firewall."

echo "========================================="
echo " Installation Complete!"
echo " NGINX is now running and optimized."
echo "========================================="
