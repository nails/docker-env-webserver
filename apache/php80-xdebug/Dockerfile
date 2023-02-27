FROM nails/docker-env-webserver:apache-php80

# Install: configuration files
COPY templates/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install: Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
