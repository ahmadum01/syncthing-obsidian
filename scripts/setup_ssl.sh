#!/bin/bash

SSL_ENABLED="$1"
DOMAIN="$2"
EMAIL="$3"

if ! ${SSL_ENABLED}; then
    echo "SSL_ENABLED value is false" 2>&1
    exit 1
elif [[ -z "$DOMAIN" ]]; then
  echo "DOMAIN value is empty" 2>&1
  exit 1
fi

echo "Create first nginx config"
envsubst '${DOMAIN}' < ./nginx/templates/nginx.conf.template > ./nginx/nginx.conf

echo "Run docker-containers"
docker compose --profile with_ssl up --build --remove-orphans -d

echo "Get ssl certificates"
docker compose run certbot certonly --webroot --webroot-path=/var/www/certbot --email "$EMAIL" --agree-tos --no-eff-email -d "$DOMAIN"

echo "Create second nginx config"
export DOMAIN=${DOMAIN} && envsubst '$${DOMAIN}' < ./nginx/templates/nginx.ssl.conf.template > ./nginx/nginx.conf

echo "Reload nginx"
docker compose exec nginx nginx -s reload

