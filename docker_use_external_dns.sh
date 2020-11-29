#!/bin/bash

set -ex

# Edit Docker daemon config file to set a custom DNS for the host
sudo vi /etc/docker/daemon.json

# Add the following entry
{
  "dns": ["8.8.8.8"]
}

# Restart Docker
sudo systemctl restart docker

# Run a container with a custom DNS and test with nslookup
docker run --dns 8.8.4.4 nicolaka/netshoot nslookup google.com