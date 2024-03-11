#!/bin/bash

# Update PHP-FPM Configuration
sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/" "/etc/php/7.3/fpm/pool.d/www.conf";
chown -R www-data:www-data /var/www/*;
chown -R 755 /var/www/*;
mkdir -p /run/php/;
touch /run/php/php7.3-fpm.pid;

# WordPress Setup
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Wordpress: setting up..."
  mkdir -p /var/www/html

  # Download and install WP-CLI
  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp

  cd /var/www/html

  # Download and configure WordPress using WP-CLI
  wp core download --allow-root

  # Check if required environment variables are defined
  if [ -z "$WP_DATABASE_NAME" ] || [ -z "$WP_DB_USER" ] || [ -z "$WP_DB_PASSWORD" ] || [ -z "$WP_DB_HOST" ]; then
    echo "Error: Environment variables not defined."
    echo "Check that WP_DATABASE_NAME, WP_DB_USER, WP_DB_PASSWORD, and WP_DB_HOST are correctly defined in the .env file."
    exit 1
  fi

  # Obtain secret keys via the WordPress API
  wp_keys=$(curl -s "https://api.wordpress.org/secret-key/1.1/salt/")

  # Check that key import has been successful
  if [ -n "$wp_keys" ]; then
    # Generate the file wp-config.php with the new secret keys
    cat > /var/www/html/wp-config.php <<EOL
<?php
define( 'DB_NAME', '${WP_DATABASE_NAME}' );
define( 'DB_USER', '${WP_DB_USER}' );
define( 'DB_PASSWORD', '${WP_DB_PASSWORD}' );
define( 'DB_HOST', '${WP_DB_HOST}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
${wp_keys}
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', '/var/www/html/' );
}
require_once ABSPATH . 'wp-settings.php';
EOL

    echo "wp-config.php: set up!"
  else
    echo "Error obtaining secret keys from the WordPress API. Please check your Internet connection and try again."
    exit 1
  fi

  # Install WordPress, create the main admin user, and additional user if not already set up
  echo "Wordpress: creating users..."
  wp core install --allow-root --url=${WP_URL} --title=${WP_DATABASE_NAME} --admin_user=${WP_ADMIN_LOGIN} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
  wp user create --allow-root ${WP_DB_USER} ${WP_DB_EMAIL} --user_pass=${WP_DB_PASSWORD}
  echo "Wordpress: set up!"
fi

# Execute the specified command or process
exec "$@"
