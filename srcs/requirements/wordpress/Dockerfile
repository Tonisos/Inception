FROM debian:11

# Update package list and upgrade installed packages
RUN apt-get update && apt-get upgrade -y

# Install essential tools
RUN apt-get install -y wget curl

# Install PHP and MariaDB client
RUN apt-get install -y php7.3 php-fpm php-mysql mariadb-client


EXPOSE 9000

# Download and extract WordPress
WORKDIR /var/www
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz && \
    tar -xvf wordpress-6.0-fr_FR.tar.gz && \
    rm wordpress-6.0-fr_FR.tar.gz

# Set ownership of WordPress files
RUN chown -R root:root /var/www/wordpress

# Copy PHP-FPM configuration
COPY conf/www.conf /etc/php/7.3/fpm/php-fpm.conf

# Copy the auto configuration script
COPY conf/auto_config.sh /var/www/

# Download and install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Make the auto configuration script executable
RUN chmod +x /var/www/auto_config.sh

# Set the entrypoint to the auto configuration script
ENTRYPOINT [ "/var/www/auto_config.sh" ]
