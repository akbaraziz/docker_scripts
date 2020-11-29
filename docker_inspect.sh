#!/bin/bash

set -ex

# Run a Container and Inspect it
docker run -d --name nginx nginx
docker inspect <CONTAINER_ID>

# List the Containers and Images to get their ID's then inspect an image
docker container ls
docker image ls
docker inspect <IMAGE_ID>

# Create and Inspect a Service
docker service create --name nginx-svc nginx 
docker service ls 
docker inspect <SERVICE_ID>
docker inspect nginx-svc 

# Format to retrieve a subset of the data in a specific format
docker service inspect --format='{{.ID}}' nginx-svc