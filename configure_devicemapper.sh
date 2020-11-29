#!/bin/bash

set -ex

# Stop and Disable Docker
sudo systemctl stop docker
sudo systemctl disable docker

#Configure DeviceMapper in daemon.json
{
  "storage-driver": "devicemapper",
  "storage-opts": [
    "dm.directlvm_device=/dev/nvme1n1",
    "dm.thinp_percent=95",
    "dm.thinp_metapercent=1",
    "dm.thinp_autoextend_threshold=80",
    "dm.thinp_autoextend_percent=20",
    "dm.directlvm_device_force=true"
  ]
}

# Start and Enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# Check driver info
docker info