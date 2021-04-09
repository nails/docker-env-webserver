#!/usr/bin/env bash

echo "+----------------------------+"
echo "| Install Framework: Laravel |"
echo "+----------------------------+"

# --------------------------------------------------------------------------

TARGET="/var/www/html"

# --------------------------------------------------------------------------

if ! [[ -x "$(command -v laravel)" ]]; then
    echo "... installing Laravel installer"
    composer global require "laravel/installer"
fi

# Ensure Composer bin dir is in $PATH
export PATH="$PATH:$HOME/.composer/vendor/bin"

echo "... installing Laravel"
composer create-project laravel/laravel $TARGET
