#!/bin/bash

set -ex


# Stop the existing DTR replica
docker run -it --rm \
  docker/dtr:2.6.6 destroy \
  --ucp-insecure-tls \
  --ucp-username admin \
  --ucp-url https://<UCP Manager Private IP>

# Restore images
sudo tar -xzf dtr-backup-images.tar -C /var/lib/docker/volumes

# Restore DTR metadata
read -sp 'ucp password: ' UCP_PASSWORD; \
docker run -i --rm \
  --env UCP_PASSWORD=$UCP_PASSWORD \
  docker/dtr:2.6.6 restore \
  --dtr-use-default-storage \
  --ucp-url https://<UCP Manager Private IP> \
  --ucp-insecure-tls \
  --ucp-username admin \
  --ucp-node <hostname> \
  --replica-id <replica-id> \
  --dtr-external-url <dtr-external-url> < dtr-backup-metadata.tar