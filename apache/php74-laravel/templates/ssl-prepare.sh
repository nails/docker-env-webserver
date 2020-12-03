#!/bin/bash

# Remove www.
if [[ $DOMAIN =~ ^www\. ]]; then
    SSL_DOMAIN=${DOMAIN:4};
else
    SSL_DOMAIN=${DOMAIN};
fi

# --------------------------------------------------------------------------

# Calculate which domains to create a certificate for
DOMAINS=()
if [[ "$(dig +short ${SSL_DOMAIN}.)" != "" ]]; then
    DOMAINS=( "${DOMAINS[@]}" "${SSL_DOMAIN}" )
fi
if [[ "$(dig +short www.${SSL_DOMAIN}.)" != "" ]]; then
    DOMAINS=( "${DOMAINS[@]}" "www.${SSL_DOMAIN}" )
fi
DOMAINS=$(IFS=$','; echo "${DOMAINS[*]}")

if [[ ${SSL_ADDITIONAL_DOMAINS} != "" ]]; then
    DOMAINS="${DOMAINS},${SSL_ADDITIONAL_DOMAINS}"
fi
