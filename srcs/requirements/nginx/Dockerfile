FROM debian:buster

# Install nginx and openssl
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Expose port 443
EXPOSE 443

# Copy nginx default configuration
COPY ./conf/default /etc/nginx/sites-enabled/default

# Copy nginx start script
COPY ./tools/nginx_start.sh /var/www/
RUN chmod +x /var/www/nginx_start.sh

# Set the entrypoint and default command
ENTRYPOINT ["/var/www/nginx_start.sh"]
CMD ["nginx", "-g", "daemon off;"]
