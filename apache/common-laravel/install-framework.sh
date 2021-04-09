#!/usr/bin/env bash

echo "+----------------------------+"
echo "| Install Framework: Laravel |"
echo "+----------------------------+"

# --------------------------------------------------------------------------

TARGET="/home/www-bridge-user"

# --------------------------------------------------------------------------

if ! [[ -x "$(command -v laravel)" ]]; then
    echo "... installing Laravel installer"
    composer global require "laravel/installer"
fi

echo "... installing Laravel"
laravel new $TARGET --force