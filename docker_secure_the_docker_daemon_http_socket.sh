#!/bin/bash

set -ex

# Generate a Certificate Authority and server certificate for your Docker Server
openssl genrsa -aes256 -out ca-key.pm 4096

openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem -subj "/C=US/ST=Texas/L=Keller/O=Linux Academy/OU=Content/CN=$HOSTNAME"

openssl genrsa -out server-key.pem 4096

openssl req -subj "/CN=$HOSTNAME" -sha256 -new -key server-key.pem -out server.csr

echo subjectAltName = DNS:$HOSTNAME,IP:<server private IP>,IP:127.0.0.1 >> extfile.cnf

echo extendedKeyUsage = serverAuth >> extfile.cnf

openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out server-cert.pem -extfile extfile.cnf

# Generate the Client Certificates
openssl genrsa -out key.pem 4096

openssl req -subj '/CN=client' -new -key key.pem -out client.csr

echo extendedKeyUsage = clientAuth > extfile-client.cnf

openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out cert.pem -extfile extfile-client.cnf

# Set appropriate permissions on the certificate files
chmod -v 0400 ca-key.pem key.pem server-key.pem
chmod -v 0444 ca.pem server-cert.pem cert.pem

# Configure your Docker host to use tlsverify mode with the certificates that were created
sudo vi /etc/docker/daemon.json

{
  "tlsverify": true,
  "tlscacert": "/home/cloud_user/ca.pem",
  "tlscert": "/home/cloud_user/server-cert.pem",
  "tlskey": "/home/cloud_user/server-key.pem"
}

# Edit Docker Service
vi /lib/systemd/system/docker.service
#change the line that begins with ExecStart and change the -H so that it looks like this
ExecStart=/usr/bin/dockerd -H=0.0.0.0:2376 --containerd=/run/containerd/containerd.sock
sudo systemctl daemon-reload
sudo systemctl restart docker

# Copy the CA Cert and Client certificates on to the client machine
scp ca.pem cert.pem key.pem user@<client private ip>:/home/user

# On the client machine, configure the client to securley connect to the remote Docker daemon
mkdir -p ~/.docker
cp -v {ca,cert,key}.pem ~/.docker
export DOCKER_HOST=tcp://<docker server private IP>:2376 DOCKER_TLS_VERIFY=1

# Test the connection
docker version 