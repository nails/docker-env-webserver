#!/usr/bin/env bash

echo "+------------------------------+"
echo "| Install Framework: WordPress |"
echo "+------------------------------+"

# --------------------------------------------------------------------------

echo "... installing WordPress"
composer create-project roots/bedrock www/

# --------------------------------------------------------------------------

echo "... setting up base theme"
curl -X POST \
  https://underscores.me/ \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'underscoresme_generate=1&underscoresme_sass=1&underscoresme_name=custom-theme' \
  -o /home/www-bridge-user/web/app/themes/custom-theme.zip
unzip -q -d /home/www-bridge-user/web/app/themes/ /home/www-bridge-user/web/app/themes/custom-theme.zip
rm -f /home/www-bridge-user/web/app/themes/custom-theme.zip

# --------------------------------------------------------------------------

echo "... Generating configs"
AUTH_KEY=`openssl rand -base64 64 | tr -d '\n'`
SECURE_AUTH_KEY=`openssl rand -base64 64 | tr -d '\n'`
LOGGED_IN_KEY=`openssl rand -base64 64 | tr -d '\n'`
NONCE_KEY=`openssl rand -base64 64 | tr -d '\n'`
AUTH_SALT=`openssl rand -base64 64 | tr -d '\n'`
SECURE_AUTH_SALT=`openssl rand -base64 64 | tr -d '\n'`
LOGGED_IN_SALT=`openssl rand -base64 64 | tr -d '\n'`
NONCE_SALT=`openssl rand -base64 64 | tr -d '\n'`

echo "# WP Configs" > /home/www-bridge-user/.env
echo 'DB_HOST=${DB_HOST}' >> /home/www-bridge-user/.env
echo 'DB_NAME=${DB_DATABASE}' >> /home/www-bridge-user/.env
echo 'DB_USER=${DB_USERNAME}' >> /home/www-bridge-user/.env
echo 'DB_PASSWORD=${DB_PASSWORD}' >> /home/www-bridge-user/.env
echo 'WP_ENV=${ENVIRONMENT}' >> /home/www-bridge-user/.env
echo 'WP_HOME=http://${DOMAIN}' >> /home/www-bridge-user/.env
echo 'WP_SITEURL=${WP_HOME}/wp' >> /home/www-bridge-user/.env
echo "AUTH_KEY='${AUTH_KEY}'" >> /home/www-bridge-user/.env
echo "SECURE_AUTH_KEY='${SECURE_AUTH_KEY}'" >> /home/www-bridge-user/.env
echo "LOGGED_IN_KEY='${LOGGED_IN_KEY}'" >> /home/www-bridge-user/.env
echo "NONCE_KEY='${NONCE_KEY}'" >> /home/www-bridge-user/.env
echo "AUTH_SALT='${AUTH_SALT}'" >> /home/www-bridge-user/.env
echo "SECURE_AUTH_SALT='${SECURE_AUTH_SALT}'" >> /home/www-bridge-user/.env
echo "LOGGED_IN_SALT='${LOGGED_IN_SALT}'" >> /home/www-bridge-user/.env
echo "NONCE_SALT='${NONCE_SALT}'" >> /home/www-bridge-user/.env

# --------------------------------------------------------------------------

echo "... Generating build and watch scripts"
mkdir -p /home/www-bridge-user/scripts
cp /install-framework/scripts/build.sh /home/www-bridge-user/scripts/build.sh
cp /install-framework/scripts/watch.sh /home/www-bridge-user/scripts/watch.sh
cp /install-framework/theme/package.json /home/www-bridge-user/web/app/themes/custom-theme/package.json
cp /install-framework/theme/webpack.config.js /home/www-bridge-user/web/app/themes/custom-theme/webpack.config.js
cp /install-framework/theme/theme.js /home/www-bridge-user/web/app/themes/custom-theme/js/theme.js
chmod +x /home/www-bridge-user/scripts/build.sh
chmod +x /home/www-bridge-user/scripts/watch.sh

# Inject the custom JS into the theme
# Is this an ugly hack? ¯\_(ツ)_/¯
echo "" >> /home/www-bridge-user/web/app/themes/custom-theme/functions.php
echo "function custom_theme_scripts_2() {" >> /home/www-bridge-user/web/app/themes/custom-theme/functions.php
echo "    wp_enqueue_script('custom-theme-js', get_template_directory_uri() . '/js/theme.min.js');" >> /home/www-bridge-user/web/app/themes/custom-theme/functions.php
echo "}" >> /home/www-bridge-user/web/app/themes/custom-theme/functions.php
echo "add_action('wp_enqueue_scripts', 'custom_theme_scripts_2');" >> /home/www-bridge-user/web/app/themes/custom-theme/functions.php
echo "" >> /home/www-bridge-user/web/app/themes/custom-theme/functions.php

# --------------------------------------------------------------------------

# Copy the welcome file
rm -f /home/www-bridge-user/web/index.php
cp /install-framework/index.php /home/www-bridge-user/web/index.php
