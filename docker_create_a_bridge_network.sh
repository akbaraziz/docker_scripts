#!/bin/bash

set -ex

# Create a bridged network and demonstrate that two containers can communicate using the network
docker network create my-net
docker run -d --name my-net-busybox --network my-net radial/busyboxplus:curl sleep 3600
docker run -d --name my-net-nginx nginx
docker network connect my-net my-net-nginx
docker exec my-net-busybox curl my-net-nginx:80

# Create a container with a network alias and communicate with it from another container using both the name and the alias
docker run -d --name my-net-nginx2 --network my-net --network-alias my-nginx-alias nginx
docker exec my-net-busybox curl my-net-nginx2:80
docker exec my-net-busybox curl my-nginx-alias:80

# Create a container and provide a network alias with the docker network connect command
docker run -d --name my-net-nginx3 nginx
docker network connect --alias another-alias my-net my-net-nginx3
docker exec my-net-busybox curl another-alias:80

# Manage existing networks on a Docker host
docker network ls
docker network inspect my-net
docker network disconnect my-net my-net-nginx
docker network rm my-net