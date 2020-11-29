#!/bin/bash

set -ex

# Trust the DTR certificate and authenticate the local daemon against DTR
curl -k https://<DTR server private IP>:443/ca > dtr.crt
sudo mkdir -p /etc/docker/certs.d/<DTR server private IP>
sudo cp dtr.crt /etc/docker/certs.d/<DTR server private IP>/
docker login <DTR server private IP>

# Pull an image, retag it, and push it to DTR
docker pull alpine:latest
docker tag alpine:latest <DTR server private IP>/admin/alpine:latest
docker push <DTR server private IP>/admin/alpine:latest

