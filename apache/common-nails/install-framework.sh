#!/usr/bin/env bash

echo "+--------------------------+"
echo "| Install Framework: Nails |"
echo "+--------------------------+"

# --------------------------------------------------------------------------

TARGET="/var/www/html"

# --------------------------------------------------------------------------

if ! [[ -x "$(command -v nails)" ]]; then
    echo "... installing Nails Command Line Tool"
    composer global require "nails/command-line-tool"
fi

# Ensure Composer bin dir is in $PATH
export PATH="$PATH:$HOME/.composer/vendor/bin"

echo "... installing Nails"
nails new:project --dir="$TARGET" --no-docker
