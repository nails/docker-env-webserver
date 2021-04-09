#!/usr/bin/env bash

echo "+------------------------------+"
echo "| Install Framework: WordPress |"
echo "+------------------------------+"

# --------------------------------------------------------------------------

$SOURCE="/install-framework"
$TARGET="/home/www-bridge-user"

# --------------------------------------------------------------------------

echo "... installing WordPress"
composer create-project roots/bedrock $TARGET

# --------------------------------------------------------------------------

echo "... setting up base theme"
curl -X POST \
  https://underscores.me/ \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'underscoresme_generate=1&underscoresme_sass=1&underscoresme_name=custom-theme' \
  -o "$TARGET/web/app/themes/custom-theme.zip"
unzip -q -d "$TARGET/web/app/themes/" "$TARGET/web/app/themes/custom-theme.zip"
rm -f "$TARGET/web/app/themes/custom-theme.zip"

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

echo "# WP Configs" > "$TARGET/.env"
echo 'DB_HOST=${DB_HOST}' >> "$TARGET/.env"
echo 'DB_NAME=${DB_DATABASE}' >> "$TARGET/.env"
echo 'DB_USER=${DB_USERNAME}' >> "$TARGET/.env"
echo 'DB_PASSWORD=${DB_PASSWORD}' >> "$TARGET/.env"
echo 'WP_ENV=${ENVIRONMENT}' >> "$TARGET/.env"
echo 'WP_HOME=http://${DOMAIN}' >> "$TARGET/.env"
echo 'WP_SITEURL=${WP_HOME}/wp' >> "$TARGET/.env"
echo "AUTH_KEY='${AUTH_KEY}'" >> "$TARGET/.env"
echo "SECURE_AUTH_KEY='${SECURE_AUTH_KEY}'" >> "$TARGET/.env"
echo "LOGGED_IN_KEY='${LOGGED_IN_KEY}'" >> "$TARGET/.env"
echo "NONCE_KEY='${NONCE_KEY}'" >> "$TARGET/.env"
echo "AUTH_SALT='${AUTH_SALT}'" >> "$TARGET/.env"
echo "SECURE_AUTH_SALT='${SECURE_AUTH_SALT}'" >> "$TARGET/.env"
echo "LOGGED_IN_SALT='${LOGGED_IN_SALT}'" >> "$TARGET/.env"
echo "NONCE_SALT='${NONCE_SALT}'" >> "$TARGET/.env"

# --------------------------------------------------------------------------

echo "... Generating build and watch scripts"
mkdir -p "$TARGET/scripts"
cp "$SOURCE/scripts/build.sh" "$TARGET/scripts/build.sh"
cp "$SOURCE/scripts/watch.sh" "$TARGET/scripts/watch.sh"
cp "$SOURCE/theme/package.json" "$TARGET/web/app/themes/custom-theme/package.json"
cp "$SOURCE/theme/webpack.config.js" "$TARGET/web/app/themes/custom-theme/webpack.config.js"
cp "$SOURCE/theme/theme.js" "$TARGET/web/app/themes/custom-theme/js/theme.js"
chmod +x "$TARGET/scripts/build.sh"
chmod +x "$TARGET/scripts/watch.sh"

# Inject the custom JS into the theme
# Is this an ugly hack? ¯\_(ツ)_/¯
echo "" >> "$TARGET/web/app/themes/custom-theme/functions.php"
echo "function custom_theme_scripts_2() {" >> "$TARGET/web/app/themes/custom-theme/functions.php"
echo "    wp_enqueue_script('custom-theme-js', get_template_directory_uri() . '/js/theme.min.js');" >> "$TARGET/web/app/themes/custom-theme/functions.php"
echo "}" >> "$TARGET/web/app/themes/custom-theme/functions.php"
echo "add_action('wp_enqueue_scripts', 'custom_theme_scripts_2');" >> "$TARGET/web/app/themes/custom-theme/functions.php"
echo "" >> "$TARGET/web/app/themes/custom-theme/functions.php"

# --------------------------------------------------------------------------

# Copy the welcome file
rm -f "$TARGET/web/index.php"
cp "/install-framework/index.php" "$TARGET/web/index.php"
