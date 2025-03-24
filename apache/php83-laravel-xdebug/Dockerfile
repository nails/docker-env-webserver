FROM nails/docker-env-webserver:apache-php83-laravel

# Install: configuration files
COPY templates/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install: Xdebug
RUN pecl install xdebug-3.4.2 \
    && docker-php-ext-enable xdebug
