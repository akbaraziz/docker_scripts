#!/bin/bash

set -ex

# Login to hub.docker.com

# Generate a delegation key pair
cd ~/
docker trust key generate <your dockerhub username>

docker trust signer add --key <your dockerhub username>.pub <your docker hub username><your docker hub username/dct-test

# Create and build a simple Docker image with an unsigned tag and then push to Docker Hub
mkdir ~/dct-test
cd dct-test
vi Dockerfile
    FROM busybox:latest
    CMD echo It worked!

docker build -t <your docker hub username>/dct-test:unsigned
docker push <your docker hub username>/dct-test:unsigned 

# Run the image to verify 
docker run <your docker hub username/dct-test:unsigned

# Enable Docker content trust and attempt to run the unsigned image again
export DOCKER_CONTENT_TRUST=1
docker run <your docker hub username>/dct-test:unsigned

# Build and push a signed tag to the repo. Use the password chosen earlier when running the docker trust key generate command
docker build -t <your docker hub username>/dct-test:signed .
docker trust sign <your docker hub username>/dct-test:signed

# Run it to verify that the signed image can run properly with Docker Content Trust enabled:
docker image rm <your docker hub username>/dct-test:signed
docker run <your docker hub username>/dct-test:unsinged