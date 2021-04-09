FROM nails/docker-env-webserver:apache-php74

COPY templates/install-framework.sh /install-framework.sh

# Ensure:
# – /var/www/html/public exists
# – Apache is pointing at /var/www/html/public
# – acme.sh uses the correct webroot
RUN mkdir -p /var/www/html/public && \
    sed -i "s:/var/www/html:/var/www/html/public:g" /etc/apache2/sites-available/default.conf && \
    sed -i "s:/var/www/html:/var/www/html/public:g" /ssl-create.sh
