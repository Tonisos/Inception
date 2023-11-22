FROM debian:11

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y wget vim

RUN apt-get install -y php7.3\
						php-fpm\
						php-mysql\
						mariadb-client

RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www

# Decompress the WordPress tar file
RUN tar -xvf /var/www/wordpress-6.0-fr_FR.tar.gz -C /var/www/

# Remove the tar file (optional, to reduce image size)
RUN rm /var/www/wordpress-6.0-fr_FR.tar.gz

RUN	chown -R root:root /var/www/wordpress

COPY /conf/www.conf /etc/php/7.3/fpm/php-fpm.conf
COPY /conf/auto_config.sh /var/www/

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x /var/www/auto_config.sh


RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

ENTRYPOINT [ "/var/www/auto_config.sh" ]