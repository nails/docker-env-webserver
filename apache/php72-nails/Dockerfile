FROM nails/docker-env-webserver:apache-php72

COPY templates/install-framework.sh /install-framework.sh

# Install: Nails Command Line Tool
RUN su www-bridge-user -c 'composer global config --no-plugins allow-plugins.bamarni/composer-bin-plugin true' && \
    su www-bridge-user -c 'composer global require nails/command-line-tool --no-ansi' && \
    ln -s /home/www-bridge-user/.composer/vendor/bin/nails /usr/local/bin/nails && \
    ln -s /home/www-bridge-user/.composer/vendor/bin/nails-cli /usr/local/bin/nails-cli
