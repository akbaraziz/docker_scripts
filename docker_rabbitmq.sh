#!/bin/bash

set -ex

docker run -d --hostname $HOSTNAME --name some-rabbit rabbitmq:3

#RabbitMQ install with specific user name and password
#docker run -d --hostname my-rabbit --name some-rabbit -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=password rabbitmq:3-management

#RabbitMQ install with specific cookie assigned
#docker run -d --hostname $HOSTNAME --name $HOSTNAME --network some-network -e RABBITMQ_ERLANG_COOKIE='secret cookie here' rabbitmq:3