#!/bin/bash

set -ex

# Run a container and access the container logs
docker run --name log-container busybox echo Here is my container log!
docker logs log-container

# Run a service and access the service logs
docker service create --name log-svc --replicas 3 -p 8080:80 nginx
curl localhost:8080
docker service logs logs-svc

# Check the Docker daemon logs
sudo journalctl -u docker

# Create a custom network with a container, and attach a netshoot container to the network
# for troubleshooting
docker network create custom-net 
docker run -d --name custom-net-nginx --network custom-net nginx

# Inject a netshoot container into another container's network sandbox
docker run --rm --network custom-net nicolaka/netshoot curl custom-net-nginx:80
docker run --rm --network container:custom-net-nginx nicolaka/netshoot curl localhost:80

# Inject a netshoot container into the sandbox of a container that uses the none network
docker run -d --name none-net-nginx --network none nginx
docker run --rm --network container:none-net-nginx nicolaka/netshoot curl localhost:80