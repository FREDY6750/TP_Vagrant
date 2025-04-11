#!/bin/bash

# Mettre à jour le système
sudo apt-get update

# Installer Nginx
sudo apt-get install -y nginx

# Configurer Nginx comme Load Balancer
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOL
upstream backend {
    server 192.168.56.11;
    server 192.168.56.12;
}

server {
    listen 80;

    location / {
        proxy_pass http://backend;
    }
}
EOL

# Redémarrer Nginx
sudo systemctl restart nginx