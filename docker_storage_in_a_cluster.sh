#!/bin/bash

set -ex

# Install the vieux/sshfs plugin on all nodes in the swarm
docker plugin install --grant-all-permissions vieux/sshfs

# Setup an additional server to use for storage
mkdir /home/user/external
echo External Storage! > /home/user/external/message.txt

# On Swarm Manager, manually create a Docker volume that uses the external storage server for storage
docker volume create --driver vieux/sshfs -o sshcmd=user@<Storage_Server_IP>:/home/user/external -o password=<PASSWORD> sshvolume
docker volume ls

# Create a service that automatically manages the shared volume, creating the volume on swarm nodes as needed. 
docker service create --replicas=3 --name storage-service --mount volume-driver=vieux/sshfs,source=cluster-volume,destination=/app,volume-opt \
    =sshcmd=user@<Storage_Server_IP>:/home/user/external,volume-opt=password=<PASSWORD> busybox cat /app/message.txt 

# Check the service logs to verify that the service is reading the test data from the external storage server
docker service logs storage-service 