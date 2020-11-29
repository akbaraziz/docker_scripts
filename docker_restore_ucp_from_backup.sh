#!/bin/bash

set -ex

# Uninstall UCP on the UCP manager service
docker container run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name ucp \
  docker/ucp:3.1.5 uninstall-ucp --interactive

# Restore UCP from the backup
docker container run --rm -i --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock  \
  docker/ucp:3.1.5 restore --passphrase "secretsecret" < /home/cloud_user/ucp-backup.tar