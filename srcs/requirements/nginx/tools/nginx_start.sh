#!/bin/bash

# Generate a self-signed SSL certificate if it doesn't exist
if [ ! -f /etc/ssl/certs/nginx.crt ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt \
    -subj "/C=FR/L=Lyon/O=42/OU=amontalb/CN=amontalb.42.fr"
fi
