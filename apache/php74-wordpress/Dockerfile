FROM nails/docker-env-webserver:apache-php74

# Ensure /var/www/html/web exists and that Apache is pointing at it
RUN mkdir -p /var/www/html/web && \
    sed -i "s:/var/www/html:/var/www/html/web:g" /etc/apache2/sites-available/default.conf
