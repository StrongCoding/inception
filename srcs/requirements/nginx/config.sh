#!/bin/bash

# Define the configuration
config='
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://wordpressphp:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}'

# Append the configuration to the Nginx configuration file
echo "$config" >> /etc/nginx/conf.d/default.conf