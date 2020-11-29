#!/bin/bash

set -ex

# Create Docker Services
docker service create nginx

# Create NGINX Service with specified name, replicas, and published port
docker service create --name nginx --replicas 3 -p 8080:80 nginx

# Use a template to pass the node hostname to each container as an env variable
docker service create --name node-hostname --replicas 3 --env NODE_HOSTNAME="{{.Node.Hostname}}" nginx

# Get the container running on the current machine and print its environment variables to verify that the NODE_HOSTNAME variable is set properly
docker ps 
docker exec <CONTAINER_ID> printenv

# List the Services in the Cluster
docker service ls 

# List the tasks for a service
docker service ps nginx 

# Inspect a Service
docker service inspect nginx
docker service inspect --pretyy nginx

# Change a Service
docker service update --replicas 2 nginx

# Delete a Service
docker service rm nginx

# Create a global Service
docker service create --name nginx --mode global nginx

# Two different ways to scale a service
docker service update --replicas 3 nginx
docker service scale nginx=4
