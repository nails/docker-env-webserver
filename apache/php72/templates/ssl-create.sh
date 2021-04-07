#!/bin/bash

source /ssl-prepare.sh

# --------------------------------------------------------------------------

echo "Installing SSL certificate for ${SSL_DOMAIN}"

# --------------------------------------------------------------------------

# Generate certificate and set variables
if [[  "${SSL_DOMAIN}" != "localhost"  ]]; then

    echo "Generating certificate for:"
    echo ${DOMAINS}

    /root/.acme.sh/acme.sh \
        --issue \
        --domain ${DOMAINS} \
        --webroot /var/www/html/web

    exitCode=$?
    # Check exit code, code 2 is a "didn't renew" so don't consider it an error
    if [ "$exitCode" != "0" ] && [ "$exitCode" != "2" ]; then
        echo "acme.sh exited with code $exitCode"
        exit $exitCode
    fi

    SSL_CERT="/root/.acme.sh/${SSL_DOMAIN}/${SSL_DOMAIN}.cer"
    SSL_KEY="/root/.acme.sh/${SSL_DOMAIN}/${SSL_DOMAIN}.key"
    SSL_CHAIN="/root/.acme.sh/${SSL_DOMAIN}/fullchain.cer"

else
    echo "Installing self-signed certificates for localhost:"
    SSL_CERT="/etc/ssl/localhost/localhost.crt"
    SSL_KEY="/etc/ssl/localhost/localhost.key"
    SSL_CHAIN="/etc/ssl/localhost/localhost.pem"
fi

# --------------------------------------------------------------------------

# Write the variables to Apache conf
sed -i -E "s:SSLCertificateFile(.*) (.*):SSLCertificateFile\1 ${SSL_CERT}:g" /etc/apache2/sites-available/default.conf
sed -i -E "s:SSLCertificateKeyFile(.*) (.*):SSLCertificateKeyFile\1 ${SSL_KEY}:g" /etc/apache2/sites-available/default.conf
sed -i -E "s:SSLCertificateChainFile(.*) (.*):SSLCertificateChainFile\1 ${SSL_CHAIN}:g" /etc/apache2/sites-available/default.conf

# --------------------------------------------------------------------------

# Reload apache
echo "Reloading Apache"
service apache2 reload
