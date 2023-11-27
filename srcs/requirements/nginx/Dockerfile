FROM debian:11

# Update package list and upgrade installed packages
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y nginx curl openssl

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed certificate
RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=IDF/L=Lyon/O=42/OU=42/CN=amontalbUID=amontalb"

# Copy Nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set permissions for /var/www/html
RUN chmod 755 /var/www/html \
    && chown -R www-data:www-data /var/www/html

# Create directory for Nginx PID file
RUN mkdir -p /var/run/nginx

# Copy entry point script
COPY nginx_start.sh /var/www/

# Set execute permissions for the entry point script
RUN chmod +x /var/www/nginx_start.sh

# Expose the only allowed port
EXPOSE 443

# Use ENTRYPOINT to start Nginx using the custom script
ENTRYPOINT ["/var/www/nginx_start.sh"]
