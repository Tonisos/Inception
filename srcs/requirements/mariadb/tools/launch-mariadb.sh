#!/bin/bash

# Terminate the script if an error occured
set -e

service mysql start;

# Safe install of MySQL
if [ ! -d "/var/lib/mysql/$WP_TITLE" ]

then

mysql_secure_installation << EOF

n
y
y
y
y
EOF

# Generate the database and the user with privilege for WordPress

mysql -e "CREATE DATABASE IF NOT EXISTS \`${WP_TITLE}\`;"

mysql -e "CREATE USER IF NOT EXISTS \`${WP_USER_LOGIN}\`@'localhost' IDENTIFIED BY '${WP_USER_PASSWORD}';"

mysql -e "GRANT ALL PRIVILEGES ON \`${WP_TITLE}\`.* TO \`${WP_USER_LOGIN}\`@'%' IDENTIFIED BY '${WP_USER_PASSWORD}';"

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

mysql -e "FLUSH PRIVILEGES;"

fi

mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

exec mysqld_safe