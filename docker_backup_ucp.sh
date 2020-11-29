#!/bin/bash

set -ex

# Backup UCP

# Get your UCP instance ID
docker container run --rm \
  --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:3.1.5 \
  id

# Create an encrypted backup. Enter your UCP instance ID from the previous command
docker container run \
  --log-driver none --rm \
  --interactive \
  --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:3.1.5 backup \
  --passphrase "secretsecret" \
  --id <Your UCP instance ID> > /home/cloud_user/ucp-backup.tar

# List the contents of the backup file
gpg --decrypt /home/cloud_user/ucp-backup.tar | tar --list