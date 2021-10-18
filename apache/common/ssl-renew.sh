#!/bin/bash

source /ssl-prepare.sh

# --------------------------------------------------------------------------

echo "Renewing SSL certificate for ${SSL_DOMAIN}"

# --------------------------------------------------------------------------

# Generate certificate and set variables
if [[  "${SSL_DOMAIN}" != "localhost"  ]]; then

    /root/.acme.sh/acme.sh \
        --server letsencrypt \
        --renew \
        --domain ${SSL_DOMAIN}

    exitCode=$?
    # Check exit code, code 2 is a "didn't renew" so don't consider it an error
    if [ "$exitCode" != "0" ] && [ "$exitCode" != "2" ]; then
        echo "acme.sh exited with code $exitCode"
        exit $exitCode
    fi

else
    echo "localhost detected, nothing to renew"
fi

# --------------------------------------------------------------------------

# Reload apache
echo "Reloading Apache"
service apache2 reload
