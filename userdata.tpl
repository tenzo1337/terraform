#!/bin/bash
sudo dnf update
sudo dnf install -y nginx
sudo systemctl start nginx.service
sleep 5
sudo systemctl status nginx.service
nginx -v

sudo echo "Hello World" > /usr/share/nginx/html/index.html
