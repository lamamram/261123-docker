#!/bin/sh
set -e

docker-php-ext-install pdo_mysql

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- php-fpm "$@"
fi

exec "$@"