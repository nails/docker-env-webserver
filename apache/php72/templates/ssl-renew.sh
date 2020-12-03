#!/bin/bash

source /ssl-prepare.sh

# --------------------------------------------------------------------------

echo "Renewing SSL certificate for ${SSL_DOMAIN}"

# --------------------------------------------------------------------------

# Generate certificate and set variables
if [[  "${SSL_DOMAIN}" != "localhost"  ]]; then
    /root/.acme.sh/acme.sh \
        --renew \
        --domain ${DOMAINS} || exit 1
else
        echo "localhost detected, nothing to renew"
fi

# --------------------------------------------------------------------------

# Reload apache
echo "Reloading Apache"
service apache2 reload
