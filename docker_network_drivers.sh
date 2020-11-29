#!/bin/bash

set -ex

# Create two containers and demonstrate communication between them using the host network driver
docker run -d --net host --name host_busybox radial/busyboxplus: curl sleep 3600
docker run -d --net host --name host_nginx nginx 
ip add|grep eth0
docker exec host_busybox ip add |grep eth0
docker exec host_busybox curl localhost:80
curl localhost:80

# Bridge Network Example
ip link
docker network create --driver bridge my-bridge-net
ip link
docker run -d --name bridge_nginx --network my-bridge-net nginx
docker rub --rm --name bridge_busybox --network my-bridge-net radial/busyboxplus:curl curl bridge_nginx:80

# Overlay Network Example
docker network create --driver overlay my-overlay-net
docker service create --name overlay_nginx --network my-overlay-net nginx
docker service create --name overlay_busybox --network my-overlay-net radial/busyboxplus:curl sh -c 'curl overlay_nginx:80 && sleep 3600'
docker service logs overlay_busybox

# MACVLAN Example
docker network create -d macvlan --subnet 192.168.0.0/24 --gateway 192.168.0.1 -o parent=eth0 my-macvlan-net
docker run -d --name macvlan_nginx --net my-macvlan-net nginx
docker run --rm --name macvlan_busybox --net my-macvlan-net radial/busyboxplus:curl curl 192.168.0.2:80

# No Network Driver Example
docker run --net none -d --name none_nginx nginx
docker run --rm radial/busyboxplus:curl curl none_nginx:80