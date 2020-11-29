#!/bin/bash

set -ex

# Enable Auto-Lock on running Swarm
docker swarm update --autolock=true #Make Note of the Unlock Key. You will need it to unlock the swarm cluster

# To enable when initializing new swarm 
docker swarm init --autolock

# Restart docker
docker node ls
sudo systemctl restart docker
docker node ls

# Unlock swarm
docker swarm unlock
docker node ls

# Obtain the existing unlock Key
docker swarem unlock-key 

# Rotate the Unlock Key
docker swarm unlock-key --rotate 

# Disable Auto-Lock
docker swarm update --autolock=false