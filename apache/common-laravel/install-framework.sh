#!/usr/bin/env bash

echo "+----------------------------+"
echo "| Install Framework: Laravel |"
echo "+----------------------------+"

# --------------------------------------------------------------------------

TARGET="/var/www/html"

# --------------------------------------------------------------------------

echo "... installing Laravel"
composer create-project laravel/laravel $TARGET
