FROM php:7.3-apache-bullseye

ARG PHP_XDEBUG=0
ARG PHP_BLACKFIRE=0
ARG PHP_BLACKFIRE_CLIENT_ID=""
ARG PHP_BLACKFIRE_CLIENT_TOKEN=""
ARG PHP_BLACKFIRE_SERVER_ID=""
ARG PHP_BLACKFIRE_SERVER_TOKEN=""

# Install: configuration files
COPY templates/apache2.conf /etc/apache2/
COPY templates/apache2.vhost.conf /etc/apache2/sites-available/default.conf
COPY templates/php.ini /usr/local/etc/php/
COPY templates/xdebug.ini /usr/local/etc/php/conf.d/
COPY templates/blackfire.ini /usr/local/etc/php/conf.d/zz-blackfire.ini
COPY templates/opcache.ini /usr/local/etc/php/conf.d/
COPY templates/ssl-prepare.sh /ssl-prepare.sh
COPY templates/ssl-create.sh /ssl-create.sh
COPY templates/ssl-renew.sh /ssl-renew.sh
COPY templates/cron.sh /cron.sh
COPY templates/install-framework.sh /install-framework.sh

# Install SSL certificate
COPY templates/ssl/localhost.crt /etc/ssl/localhost/cert.crt
COPY templates/ssl/localhost.csr /etc/ssl/localhost/csr.csr
COPY templates/ssl/localhost.key /etc/ssl/localhost/key.key
COPY templates/ssl/localhost.pem /etc/ssl/localhost/fullchain.pem

RUN useradd -u 1000 -m www-bridge-user && \
    cp /etc/skel/.bashrc ~/ && \
    cp /etc/skel/.profile ~/ && \
    # Install: dependencies
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        cron \
        curl \
        default-mysql-client \
        dnsutils \
        git \
        gnupg2 \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libnotify-bin \
        libpng-dev \
        libzip-dev \
        logrotate \
        python \
        rsyslog \
        ssh-client \
        unzip \
        vim \
        zip && \
    # Purge so apt-get update is more reliable
    rm -rf /var/lib/apt/lists/* && \
    # Logging: Enable cron logs
    sed -i "s:#cron:cron:g" /etc/rsyslog.conf && \
    # Install acme.sh
    curl https://get.acme.sh | sh && \
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade && \
    # Install: Node, n, and yarn
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y \
        nodejs && \
    npm install -gy \
        n \
        yarn && \
    # Install: PHP extensions
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install \
        curl \
        gd \
        intl \
        mysqli \
        pdo \
        pdo_mysql \
        zip && \
    # Install: Xdebug
    if [ "$PHP_XDEBUG" = "1" ]; then pecl install xdebug; else rm /usr/local/etc/php/conf.d/xdebug.ini; fi && \
    # Install: Blackfire
    if [ "$PHP_BLACKFIRE" = "1" ]; then echo "Installing Blackfire"; else rm /usr/local/etc/php/conf.d/zz-blackfire.ini; fi && \
    if [ "$PHP_BLACKFIRE" = "1" ]; then curl -sS https://packages.blackfire.io/gpg.key | apt-key add -; fi && \
    if [ "$PHP_BLACKFIRE" = "1" ]; then echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list; fi && \
    if [ "$PHP_BLACKFIRE" = "1" ]; then apt-get update -y; fi && \
    if [ "$PHP_BLACKFIRE" = "1" ]; then apt-get install -y --no-install-recommends blackfire-agent; fi && \
    if [ "$PHP_BLACKFIRE" = "1" ]; then blackfire-agent --register --server-id=$PHP_BLACKFIRE_SERVER_ID --server-token=$PHP_BLACKFIRE_SERVER_TOKEN; fi && \
    if [ "$PHP_BLACKFIRE" = "1" ]; then apt-get install -y --no-install-recommends blackfire-php; fi && \
    if [ "$PHP_BLACKFIRE" = "1" ]; then su www-bridge-user -c "blackfire config --client-id=$PHP_BLACKFIRE_CLIENT_ID --client-token=$PHP_BLACKFIRE_CLIENT_TOKEN"; fi && \
    if [ "$PHP_BLACKFIRE" = "1" ]; then /etc/init.d/blackfire-agent restart; fi && \
    # Install: composer
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer && \
    echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> /home/www-bridge-user/.bashrc && \
    # Configure: Apache vhosts
    a2dissite 000-default && \
    a2dissite default-ssl && \
    a2ensite default && \
    rm -f /etc/apache2/sites-available/000-default.conf && \
    rm -f /etc/apache2/sites-available/default-ssl.conf && \
    # Enable: Apache modules
    curl -fsSl "https://dl.google.com/linux/linux_signing_key.pub" | apt-key add - && \
    curl "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb" > ~/mod_pagespeed.deb && \
    dpkg -i ~/mod_pagespeed.deb && \
    apt-get install -y --no-install-recommends -f && \
    a2enmod expires && \
    a2enmod headers && \
    a2enmod rewrite && \
    a2enmod ssl && \
    # Add env vars to Apache
    touch /env-apache.sh && \
    echo ". /env-apache.sh" >> /etc/apache2/envvars && \
    # Configure services to start on boot
    update-rc.d rsyslog enable && \
    update-rc.d cron enable

# Install: bash aliases (after www-bridge-user has been created)
COPY templates/.bash_aliases /root
COPY templates/.bash_aliases /home/www-bridge-user

# Late install of some config files
COPY templates/pagespeed.conf /etc/apache2/mods-available/
