FROM debian:buster

# Update package list and upgrade installed packages
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y nginx vim curl openssl

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf

# Generate a self-signed certificate
RUN openssl req -x509 -nodes \
		-out /etc/nginx/ssl/inception.crt \
		-keyout /etc/nginx/ssl/inception.key \
		-subj "/C=FR/ST=IDF/L=Lyon/O=42/OU=42/CN=amontalbUID=amontalb"

RUN mkdir -p /var/run/nginx


#the only port allowed
# EXPOSE	443

# RUN chmod 755 /var/www/html
# RUN chown -R www-data:www-data /var/www/html

# CMD to start Nginx in the foreground
# CMD ["nginx", "-g", "daemon off;"]