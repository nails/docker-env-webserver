FROM nails/docker-env-webserver:apache-php73-nails

# Install: configuration files
COPY templates/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install: Xdebug
RUN pecl install xdebug-3.1.5 \
    && docker-php-ext-enable xdebug
