#!/bin/bash

source /ssl-prepare.sh

# --------------------------------------------------------------------------

echo "Installing SSL certificate for ${SSL_DOMAIN}"

# --------------------------------------------------------------------------

# Generate certificate and set variables
if [[  "${SSL_DOMAIN}" != "localhost"  ]]; then

    echo "Generating certificate for:"
    echo ${DOMAINS}

    /root/acme.sh/acme.sh \
        --server letsencrypt \
        --issue \
        --domain ${DOMAINS} \
        --webroot /var/www/html

    exitCode=$?
    # Check exit code, code 2 is a "didn't renew" so don't consider it an error
    if [ "$exitCode" != "0" ] && [ "$exitCode" != "2" ]; then
        echo "acme.sh exited with code $exitCode"
        exit $exitCode
    fi

    mkdir -p /etc/ssl/active

    SSL_CERT="/etc/ssl/active/cert.crt"
    SSL_KEY="/etc/ssl/active/key.key"
    SSL_CHAIN="/etc/ssl/active/fullchain.pem"

    /root/acme.sh/acme.sh \
        --install-cert \
        -d ${SSL_DOMAIN} \
        --cert-file "${SSL_CERT}" \
        --key-file "${SSL_KEY}" \
        --fullchain-file "${SSL_CHAIN}"

else
    echo "Installing self-signed certificates for localhost:"
    SSL_CERT="/etc/ssl/localhost/cert.crt"
    SSL_KEY="/etc/ssl/localhost/key.key"
    SSL_CHAIN="/etc/ssl/localhost/fullchain.pem"
fi

# --------------------------------------------------------------------------

# Write the variables to Apache conf
sed -i -E "s:SSLCertificateFile(.*) (.*):SSLCertificateFile\1 ${SSL_CERT}:g" /etc/apache2/sites-available/default.conf
sed -i -E "s:SSLCertificateKeyFile(.*) (.*):SSLCertificateKeyFile\1 ${SSL_KEY}:g" /etc/apache2/sites-available/default.conf
sed -i -E "s:SSLCertificateChainFile(.*) (.*):SSLCertificateChainFile\1 ${SSL_CHAIN}:g" /etc/apache2/sites-available/default.conf

# --------------------------------------------------------------------------

echo "Reloading Apache:"
service apache2 reload
