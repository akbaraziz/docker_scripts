#!/bin/bash

set -ex

# Create a Simple Registry
docker run -d -p 5000:5000 --restart=always --name registry registry:2
docker container stop registry && docker container rm -v registry

# Override Log Level
docker logs registry
docker container stop registry && docker container rm -v registry
docker run -d -p 5000:5000 --restart=always --name registry -e REGISTRY_LOG_LEVEL=debug registry:2
docker logs registry
docker container stop registry && docker container rm -v registry

# Secure the registry with htpasswd file
mkdir ~/registry
cd ~/registry
mkdir auth
docker run --entrypoint htpasswd registry:2 -Bbn testuser password > auth/htpasswd

# Generate Self-Signed Certificate
mkdir certs
openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
  -x509 -days 365 -out certs/domain.crt

# Run Registry with TLS enabled
docker run -d -p 443:443 --restart=always --name registry \
  -v /home/cloud_user/registry/certs:/certs \
  -v /home/cloud_user/registry/auth:/auth \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  -e REGISTRY_AUTH=htpasswd \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  registry:2

