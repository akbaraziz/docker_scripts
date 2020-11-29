#!/bin/bash

set -ex

# Create a Compose file for the Stack
vi simple-stack.yml

version: '3'
services:
  web:
    image: nginx
  busybox:
    image: radial/busyboxplus:curl
    command: /bin/sh -c "while true; do echo Hello!; sleep 10; done"

# Deploy the stack and examine it using various commands
docker stack deploy -c simple-stack.yml simple
docker stack ls
docker stack ps simple
docker stack services simple
docker service logs simple_busybox

# Modify the stack to use an env variable
vi simple-stack.yml
version: '3'
services:
  web:
    image: nginx
  busybox:
    image: radial/busyboxplus:curl
    command: /bin/sh -c "while true; do echo $$MESSAGE; sleep 10; done"
    environment:
    - MESSAGE=Hello!

docker stack deploy -c simple-stack.yml simple
docker service logs simple_busybox

# Modify the stack to expose a port
vi simple-stack.yml
version: '3'
services:
  web:
    image: nginx
    ports:
    - "8080:80"
  busybox:
    image: radial/busyboxplus:curl
    command: /bin/sh -c "while true; do echo $$MESSAGE; sleep 10; done"
    environment:
    - MESSAGE=Hello!

docker stack deploy -c simple-stack.yml simple
curl localhost:8080

# Modify the stack to use the BusyBox service to communicate with the web service
vi simple-stack.yml
version: '3'
services:
  web:
    image: nginx
    ports:
    - "8080:80"
  busybox:
    image: radial/busyboxplus:curl
    command: /bin/sh -c "while true; do echo $$MESSAGE; curl web:80; sleep 10; done"
    environment:
    - MESSAGE=Hello!

    docker stack deploy -c simple-stack.yml simple

# Delete the stack
docker stack rm simple 
