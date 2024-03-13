#!/bin/bash

# Mise à jour de la configuration PHP-FPM
# Remplace la directive d'écoute par défaut dans le fichier de configuration PHP-FPM pour écouter sur le port 9000
sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/" "/etc/php/7.3/fpm/pool.d/www.conf";

# Change les propriétaires et les permissions des fichiers dans le répertoire /var/www/ en www-data:www-data et 755, respectivement
chown -R www-data:www-data /var/www/*;
chown -R 755 /var/www/*;

# Crée le répertoire /run/php/ s'il n'existe pas et crée un fichier vide php7.3-fpm.pid à l'intérieur
mkdir -p /run/php/;
touch /run/php/php7.3-fpm.pid;

# Configuration de WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
  mkdir -p /var/www/html

  # Télécharge et installe WP-CLI
  # Télécharge le fichier phar de WP-CLI depuis GitHub et le rend exécutable
  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp

  cd /var/www/html

  # Télécharge et configure WordPress en utilisant WP-CLI
  wp core download --allow-root

  # Vérifie si les variables d'environnement requises sont définies
  if [ -z "$WP_DATABASE_NAME" ] || [ -z "$WP_DB_USER" ] || [ -z "$WP_DB_PASSWORD" ] || [ -z "$WP_DB_HOST" ]; then
    exit 1
  fi

  # Obtient les clés secrètes via l'API WordPress
  wp_keys=$(curl -s "https://api.wordpress.org/secret-key/1.1/salt/")

  # Vérifie que l'importation des clés s'est bien déroulée
  if [ -n "$wp_keys" ]; then
    # Génère le fichier wp-config.php avec les nouvelles clés secrètes et les configurations de la base de données
    cat > /var/www/html/wp-config.php <<EOL
<?php
define( 'DB_USER', '${WP_DB_USER}' );
define( 'DB_PASSWORD', '${WP_DB_PASSWORD}' );
define( 'DB_NAME', '${WP_DATABASE_NAME}' );
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

  else
    exit 1
  fi

  # Installe WordPress, crée l'utilisateur admin principal et un utilisateur supplémentaire s'ils ne sont pas déjà configurés
  wp core install --allow-root --url=${WP_URL} --title=${WP_DATABASE_NAME} --admin_user=${WP_ADMIN_LOGIN} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
  wp user create --allow-root ${WP_DB_USER} ${WP_DB_EMAIL} --user_pass=${WP_DB_PASSWORD}
fi

exec "$@"
