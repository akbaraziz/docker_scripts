#!/bin/bash

set -ex

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version

# Setup a Docker Compose Object
mkdir nginx-compose
cd nginx-compose
vi docker-compose.yml

# Create your own docker-compose.yml
version: '3'
services:
  web:
    image: nginx
    ports:
    - "8080:80"
  redis:
    image: redis:alpine

# Start your Compose app
docker -compose up -d

# List the Docker Compose Containers then stop the app
docker-compose ps 
docker-compose down
