#!/bin/bash

service mysql start;

mysql -e "CREATE DATABASE IF NOT EXISTS \`${WP_TITLE}\`;"

mysql -e "CREATE USER IF NOT EXISTS \`${WP_USER_LOGIN}\`@'localhost' IDENTIFIED BY '${WP_USER_PASSWORD}';"

mysql -e "GRANT ALL PRIVILEGES ON \`${WP_TITLE}\`.* TO \`${WP_USER_LOGIN}\`@'%' IDENTIFIED BY '${WP_USER_PASSWORD}';"

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

mysql -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

exec mysqld_safe