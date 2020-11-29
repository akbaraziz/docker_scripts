#!/bin/bash

set -ex

# How to pull and search for images on DockerHub
docker pull ubuntu
docker search ubuntu

# Attempt to authenticate against the private registry
docker login <registry public hostname>

# Configure Docker to ignore certificate verification when accessing the private registry - THIS IS A BAD THING
sudo vi /etc/docker/daemon.json
    {
        "insecure-registries" : ["<registry public hostname>"]
    }

# Restart Docker
sudo systemctl restart docker

# Try Docker Login again
docker login <registry public hostname>

# Log out of the Private registry
docker logout <registry public hostname>

# Remove insecurity entry from daemon.json

# Restart Docker
sudo systemctl restart docker

# Download Cert Public Key from the Registry and configure Docker to use insecurity
sudo mkdir -p /etc/docker/certs.d/<registry public hostname>
sudo scp cloud_user@<registry public hostname>:/home/cloud_user/registry/certs/domain.crt /etc/docker/certs.d/<registry public hostname>

# Login to Docker
docker login <registry public hostname>

# Push and Pull from Registry
docker pull ubuntu
docker tag ubuntu <registry public hostname>/ubuntu
docker push <registry public hostname>/ubuntu
docker image rm <registry public hostname>/ubuntu
docker image rm ubuntu
docker pull <registry public hostname>/ubuntu

