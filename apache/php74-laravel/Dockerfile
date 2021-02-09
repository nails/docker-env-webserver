FROM nails/docker-env-webserver:apache-php74

# Ensure /var/www/html/public exists and that Apache is pointing at it
RUN mkdir -p /var/www/html/public && \
    sed -i "s:/var/www/html:/var/www/html/public:g" /etc/apache2/sites-available/default.conf
