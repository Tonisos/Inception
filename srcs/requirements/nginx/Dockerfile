FROM debian:11

# Update package list and upgrade installed packages
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y nginx openssl

# Expose the only allowed port
EXPOSE 443


# Copy Nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set permissions for /var/www/html
RUN chmod 755 /var/www/html \
    && chown -R www-data:www-data /var/www/html


# Copy entry point script
COPY tools/nginx-start.sh /var/www/

# Set execute permissions for the entry point script
RUN chmod +x /var/www/nginx-start.sh


#Use ENTRYPOINT to start Nginx using the custom script
ENTRYPOINT ["/var/www/nginx-start.sh"]

CMD ["nginx", "-g", "daemon off;"]
