#!/bin/bash

[[ -z $(docker ps -aq --filter name=app-php) ]] || docker rm -f $(docker ps -aq --filter name=app-php)

docker run \
       --name app-php-nginx \
       --restart unless-stopped -d \
       -p 8080:80 \
       nginx:trixie-perl

docker run \
       --name app-php-fpm \
       --restart unless-stopped -d \
       php:8.6.0-fpm-trixie