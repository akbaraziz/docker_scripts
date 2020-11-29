#!/bin/bash

set -ex

# Run a basic container
docker run --name storage_nginx nginx

# Use Docker Inspect to find the location of the container's data on the host
docker container inspect storage_nginx
ls /var/lib/docker/overlay2/<STORAGE_HASH>/

# User Docker Inspect to find the location of an image's data
docker image inspect nginx