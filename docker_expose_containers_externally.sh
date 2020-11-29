#!/bin/bash

set -ex

# Run a container with a published port then test and examine published ports for the container
docker run -d -p 8080:80 --name nginx_pub nginx
curl localhost:8080
docker port nginx_pub
docker ps

# Create a service with a published port using the ingress publishing mode
docker service create -p 8081:80 --name nginx_ingress_pub nginx
curl localhost:8081
docker service ps nginx_ingress_pub

# Create service published using host mode. Check which node the task is running on and attempt
# to access it from the node where the task is running and not running
docker service create -p mode=host,published=8082,target=80 --name nginx_host_pub nginx
docker service ps nginx_host_pub

# Check which node the task is running on, and access the service from that node
curl localhost:8082

# Try accessing the service from another node. It should fail
curl localhost:8082