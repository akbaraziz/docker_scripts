#!/bin/bash

set -ex

# Display the storage space being used by Docker
docker system df

# Display disu usage by individual objects
docker system df -v

# Delete dangling images (images with no tags or containers)
docker image prune

# Pull an image not being used by any contianers and clean up all
docker image pull nginx:1.14.0
docker image prune -a 
