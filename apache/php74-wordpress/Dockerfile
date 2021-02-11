FROM nails/docker-env-webserver:apache-php74

# Ensure:
# – /var/www/html/web exists
# – Apache is pointing at /var/www/html/web
# – acme.sh uses the correct webroot
RUN mkdir -p /var/www/html/web && \
    sed -i "s:/var/www/html:/var/www/html/web:g" /etc/apache2/sites-available/default.conf && \
    sed -i "s:/var/www/html:/var/www/html/web:g" /ssl-create.sh
