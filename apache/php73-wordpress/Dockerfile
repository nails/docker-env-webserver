FROM nails/docker-env-webserver:apache-php73

COPY templates/install-framework.sh /install-framework.sh
COPY templates/scripts/build.sh /install-framework/scripts/build.sh
COPY templates/scripts/watch.sh /install-framework/scripts/watch.sh
COPY templates/theme/package.json /install-framework/theme/package.json
COPY templates/theme/theme.js /install-framework/theme/theme.js
COPY templates/theme/webpack.config.js /install-framework/theme/webpack.config.js
COPY templates/index.php /install-framework/index.php

# Ensure:
# – /var/www/html/web exists
# – Apache is pointing at /var/www/html/web
# – acme.sh uses the correct webroot
RUN mkdir -p /var/www/html/web && \
    sed -i "s:/var/www/html:/var/www/html/web:g" /etc/apache2/sites-available/default.conf && \
    sed -i "s:/var/www/html:/var/www/html/web:g" /ssl-create.sh
