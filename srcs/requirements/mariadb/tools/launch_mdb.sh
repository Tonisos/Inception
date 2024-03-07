#!/bin/bash

# Start MySQL service
service mysql start

# Exit script immediately if a command fails
set -e

# Check if WordPress database directory exists
if [ ! -d "/var/lib/mysql/$WP_DATABASE_NAME" ]; then

  # Configure MySQL for WordPress
  mysql_secure_installation << END
n
y
y
y
y
END

  # Set MySQL root user password
  mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD';"

  # Create WordPress database
  mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $WP_DATABASE_NAME;"

  # Create WordPress database user
  mysql -uroot -e "CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';"

  # Grant privileges to WordPress user
  mysql -uroot -e "GRANT ALL PRIVILEGES ON $WP_DATABASE_NAME.* TO '$WP_DB_USER'@'%';"

  # Flush privileges to apply changes
  mysql -uroot -e "FLUSH PRIVILEGES;"

fi

# Shutdown MySQL service
mysqladmin -u root -p$MYSQL_ROOT_PWD shutdown

# Execute provided command
exec "$@"
