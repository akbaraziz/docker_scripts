#!/bin/bash

set -ex

# List current nodes
docker node ls 

# Add a Label to a Node
docker node update --label-add availability_zone=east <NODE_NAME>
docker node update --label-add availability_zone=west <NODE_NAME>

# View Existing Labels
docker node inspect --pretty <NODE_NAME>

# creating a service to restrict which nodes will be used to execute a service's tasks.
docker service create --name nginx-east --constraint node.labels.availability_zone==east --replicas 3 nginx
docker service ps nginx-east
docker service create --name nginx-west --constraint node.labels.availability_zone!=east --replicas 3 nginx
docker service ps nginx-west

# Spread task evenly --placement flag
docker service create --name nginx-spread --placement-pref spread=node.labels.availability_zone --replicas 3 nginx
docker service ps nginx-spread