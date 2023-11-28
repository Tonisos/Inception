FROM debian:11

# Update package list and upgrade installed packages
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install nginx openssl -y

# Expose the only allowed port
EXPOSE 443


# Copy Nginx configuration
COPY ./conf/nginx.conf /etc/nginx/sites-enabled/default

# Copy entry point script
COPY ./tools/nginx-start.sh /var/www/


# Set execute permissions for the entry point script
RUN chmod +x /var/www/nginx-start.sh


#Use ENTRYPOINT to start Nginx using the custom script
ENTRYPOINT ["/var/www/nginx-start.sh"]

CMD ["nginx", "-g", "daemon off;"]
