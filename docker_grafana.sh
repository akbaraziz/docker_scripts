#!/bin/bash

set -ex

docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_SERVER_ROOT_URL=http://localhost" \
  -e "GF_SECURITY_ADMIN_PASSWORD=secret" \
  grafana/nutanix/4u