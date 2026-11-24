#!/bin/bash

[[ -z $(docker ps -aq --filter name=app-php) ]] || docker rm -f $(docker ps -aq --filter name=app-php)

docker network ls | grep app-php > /dev/null
if [[ "$?" -eq 0 ]]; then
  docker network rm app-php
fi

# créer un réseau custom avec lequel le nom de conteneur est naturellement un dns !
docker network create \
               --driver=bridge \
               --subnet=172.18.0.0/16 \
               --gateway=172.18.0.1 \
               app-php

# associer le conteneur au réseau --net
docker run \
       --name app-php-nginx \
       --restart unless-stopped -d \
       --net app-php \
       -p 8080:80 \
       -v ./vhost.conf:/etc/nginx/conf.d/vhost.conf:ro \
       nginx:trixie-perl

# docker cp vhost.conf app-php-nginx:/etc/nginx/conf.d/
# reload le serveur
# docker restart app-php-nginx

docker run \
       --name app-php-fpm \
       --net app-php \
       --restart unless-stopped -d \
       -v ./index.php:/srv/index.php:ro \
       php:8.6.0-fpm-trixie

# docker cp ./index.php app-php-fpm:/srv
# test du cp: docker exec app-php-fpm ls /srv/index.php