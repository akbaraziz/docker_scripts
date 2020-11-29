#!/bin/bash

set -ex

# Create a directory on the host with some test data
cd ~
mkdir message
echo Hello, world! > message/message.txt

# Mount the directory to a container with a bind mount
docker run --mount type=bind,source=/home/user/message,destination=/root,readonly busybox cat /root/message.txt

# Run a containr with a mounted volume
docker run --mount type=volume,source=my-volume,destination=/root busybox sh -c 'echo hello > /root/message.txt && cat /root/message.txt'

# Use the -v syntax to create a bind mount and volume
docker run -v /home/user/message:ro busybox cat /root/message.txt
docker run -v my-volume:/root busybox -sh -c 'cat /root/message.txt'

# Use a volume to share data between containers
docker run --mount type=volume,source=shared-volume,destination=/root busybox sh -c 'echo I wrote this! > /root/message.txt'
docker run --mount type=volume,source=shared-volume,destination=/anotherplace busybox cat /anotherplace/message.txt

# Create and manage volumes using docker volume commands
docker volume create test-volume
docker volume ls
docker volume inspect test-volume
docker volume rm test-volume