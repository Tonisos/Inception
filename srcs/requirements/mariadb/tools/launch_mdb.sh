#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Start the MySQL service
service mysql start

# Check if the WordPress database directory exists
if [ ! -d "/var/lib/mysql/$WP_TITLE" ]; then

  # Configure MySQL for WordPress
  mysql_secure_installation << EOF
n
y
y
y
y
EOF

  # Create the WordPress database
  mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $WP_TITLE;"

  # Create the WordPress user
  mysql -uroot -e "CREATE USER IF NOT EXISTS '$WP_USER_LOGIN'@'%' IDENTIFIED BY '$WP_USER_PASSWORD';"

  # Grant privileges to the WordPress user
  mysql -uroot -e "GRANT ALL PRIVILEGES ON $WP_TITLE.* TO '$WP_USER_LOGIN'@'%';"

  # Flush privileges to apply changes
  mysql -uroot -e "FLUSH PRIVILEGES;"

  # Set a password for the MySQL root user
  mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

fi

# Shut down the MySQL service
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# Execute the provided command
exec "$@"
