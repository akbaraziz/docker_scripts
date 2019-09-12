#!/bin/bash

set -ex

#Install Artifactory Pro
docker pull docker.bintray.io/jfrog/artifactory-pro:latest

#Install Artifactory CE
#docker pull docker.bintray.io/jfrog/artifactory-cpp-ce

#Install Artifactory OSS
#docker pull docker.bintray.io/jfrog/artifactory-oss:latest

#Create Data Directory
mkdir -p /jfrog/artifactory
chown -R 1030 /jfrog

#Start Artifactory container
docker run --name artifactory -d -p 8081:8081 -v \
/jfrog/artifactory:/var/opt/jfrog/artifactory \
-e EXTRA_JAVA_OPTIONS='-Xms512m -Xmx2g -Xss256k -XX:+UseG1GC' \
docker.bintray.io/jfrog/artifactory-pro:latest

#Create Service for Artifactory
cat >/etc/systemd/system/artifactory.Service <<EOL
[Unit]
Description=Setup Systemd script for Artifactory Container
After=network.target

[Service]
Restart=always
ExecStartPre=-/usr/bin/docker kill artifactory
ExecStartPre=-/usr/bin/docker rm artifactory
ExecStart=/usr/bin/docker run --name artifactory -p 8081:8081 \
  -v /jfrog/artifactory:/var/opt/jfrog/artifactory \
  docker.bintray.io/jfrog/artifactory-pro:latest
ExecStop=-/usr/bin/docker kill artifactory
ExecStop=-/usr/bin/docker rm artifactory

[Install]
WantedBy=multi-user.target
EOL

#Reload Systemd
systemctl daemon-Reload

#Start Artifactory Container
systemctl start artifactory && systemctl enable artifactory 

#Check Service Bindings
echo ss -tunelp | grep 8081
