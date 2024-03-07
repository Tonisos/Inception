FROM debian:buster

# Update package repository and install PHP and dependencies
RUN apt-get update && \
    apt-get -y install php7.3 php-mysqli php-fpm wget curl

# Expose PHP-FPM port
EXPOSE 9000

# Copy PHP-FPM pool configuration
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d

# Copy tools to /var/www/
COPY ./tools /var/www/

# Make wp_launch.sh executable
RUN chmod +x /var/www/wp_launch.sh

# Set the entrypoint and default command
ENTRYPOINT ["/var/www/wp_launch.sh"]
CMD ["/usr/sbin/php-fpm7.3", "--nodaemonize"]
