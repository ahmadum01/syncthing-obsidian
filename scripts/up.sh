#!/bin/bash

SSL_ENABLED="$1"
DOMAIN="$2"


if ${SSL_ENABLED}; then

  if [[ -z "$DOMAIN" ]]; then
    echo "DOMAIN value is empty" 2>&1
    exit 1
  fi

  export DOMAIN=${DOMAIN} && envsubst '$${DOMAIN}' < ./nginx/templates/nginx.ssl.conf.template > ./nginx/nginx.conf
  docker compose --profile with_ssl up --build --remove-orphans -d
else
  cp ./nginx/templates/nginx.conf.template ./nginx/nginx.conf
  docker compose --profile without_ssl up  --build --remove-orphans
fi