#!/usr/bin/env bash

echo "+--------------------------+"
echo "| Install Framework: Nails |"
echo "+--------------------------+"

# --------------------------------------------------------------------------

TARGET="/var/www/html"

# --------------------------------------------------------------------------

echo "... installing Nails"
nails new:project --dir="$TARGET" --no-docker
