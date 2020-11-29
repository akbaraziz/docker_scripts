#!/bin/bash

set -ex

# On DTR server get the DTR Replica ID
docker volume ls

# Backup the registry images
sudo tar -zvcf dtr-backup-images.tar \
  $(dirname $(docker volume inspect --format '{{.Mountpoint}}' dtr-registry-<replica-id>))

# Backup DTR metadata
read -sp 'ucp password: ' UCP_PASSWORD; \
docker run --log-driver none -i --rm \
  --env UCP_PASSWORD=$UCP_PASSWORD \
  docker/dtr:2.6.6 backup \
  --ucp-url https://<UCP Manager Private IP> \
  --ucp-insecure-tls \
  --ucp-username admin \
  --existing-replica-id <replica-id> > dtr-backup-metadata.tar