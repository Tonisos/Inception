#!/bin/bash

# Sleep to ensure MariaDB has enough time to launch
sleep 10

# Check if wp-config.php exists
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "WordPress: setting up configuration..."

  # Use WP-CLI to configure WordPress
  wp config create --dbname=${WP_DB_NAME} --dbuser=${WP_DB_USER} --dbpass=${WP_DB_PASSWORD} --dbhost=${WP_DB_HOST} --skip-check

  echo "WordPress: configuration set up!"
else
  echo "WordPress: wp-config.php already exists."
fi

wp config create	--allow-root \
	--dbname=$SQL_DATABASE \
	--dbuser=$SQL_USER \
	--dbpass=$SQL_PASSWORD \
	--dbhost=mariadb:3306 --path='/var/www/wordpress'

# Continue with other setup steps or run the CMD passed to the Dockerfile
exec "$@"