#!/bin/bash

set -ex

# Create an encrypted overlay network
docker network create --opt encrypted --driver overlay my-encrypted-network

# Create two services on the encrypted overlay network and demonstrate
# that one service can communicate with the other
docker service create --name encrypted-overlay-nginx --network my-encrypted-net --replicas 3 nginx
docker service create --name encrypted-overlay-busybox --network my-encrypted-net radial/busyboxplus:curl \
sh -c 'curl encrypted-overlay-nginx:80 && sleep 3600'

# Verify that you can see the NGINX welcome page
docker service logs encrypted-overlay-busybox