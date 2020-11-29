#!/bin/bash

set -ex

# Deploying a Static Website on Port 80 with a name of doge


##1
#Download the Image from Docker Hub
docker pull "imagename"
# example - docker pull nginx


##2
#Run the container with port 80 and name of doge
docker run -d --name doge -p 80:80 nginx # -d means detached # 80:80 is referencing the local port and container port its listening on # --name is the name you want to give the container


##3
#Building Container Images
# Migrate a site from one OS to another (Ubuntu to CentOS 6) and pull content 
# from git repo and name it websetup
docker pull centos:6
docker run -it --name websetup centos:6 /bin/bash # -it means interactive mode
# Now you are in bash shell of the container
yum install -y httpd git
 git clone https://github.com/linuxacademy/content-dockerquest-spacebones
 cp content-dockerquest-spacebones/doge/* /var/www/html
 mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bak
 chkconfig httpd on && service httpd start
exit
# Save the edited image
docker commit websetup spacebones:thewebsite


##4 
#The Radar Board (The official SpaceBones government tech team) 
#have requested your assistance with developing a Node.js web application 
#that can be used for launching a new and improved SpaceBones webspace. 
#They have provided all of the basic files in the content-dockerquest-spacebones Github. 
#Using the example Dockerfile included in activity instructions, 
#use Docker to build a new Node.js app image using the files under 
#the content-dockerquest-spacebones/nodejs-app subdirectory, named baconator. 
#Be sure to tag the image as dev.
git clone https://github.com/linuxacademy/content-dockerquest-spacebones
# Move into the nodejs-app subdirectory
cd ~/content-dockerquest-spacebones/nodejs-app
# Create a Dockerfile to build new image
FROM node:7
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
CMD node index.js
EXPOSE 8081
# Save the file as Dockerfile
# Build the container image
docker build -t baconator.dev .
# Run the image to verify functionality
docker run -d -p 80:8081 baconator.dev


##5
#As the Radar Board prepares to integrate Saltstack with their environment 
#using Docker images, they have requested your aid with preparing a parent 
#image for what will eventually become the master node, 
#using OnBuild. Using the Dockerfile included under ~/content-dockerquest-spacebones/salt-example/salt-master/, 
#create a new parent image for the salt-master build named tablesalt:master that executes all commands against 
#docker-entrypoint.sh on any child images created from the parent image. 
#Good luck!
#Here is the content-dockerrequest repo: https://github.com/linuxacademy/content-dockerquest-spacebones
FROM jarfil/salt-master-mini:debian-stretch
MAINTAINER Jaroslaw Filiochowski <jarfil@gmail.com>
COPY . /
RUN apt-get -y update && \
	apt-get -y upgrade && \
	apt-get -y install \
		salt-minion \
		salt-ssh \
		salt-cloud && \
	apt-get -y autoremove && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/
ONBUILD RUN chmod +x \
	/docker-entrypoint.sh
EXPOSE 4505 4506
ONBUILD CMD /docker-entrypoint.sh
# Now run the docker build command to build the above docker container
docker build -t tablesalt:master .


##6 
#After consulting with the Radar Board (The official SpaceBones technology team), 
#we have decided the best option for sharing data between several containers will 
#be Docker data containers. As our resident Docker expert, we are counting on you to 
#create a data container running the training/postgres 
#image (for our purposes, name that data container 'boneyard'), then mount 
#the data container on three app containers (also running training/postgres) 
#with the following names:
#cheese
#tuna
#bacon
docker create -v /data --name boneyard spacebones/postgres /bin/true
docker run -d --volumes-from boneyard --name cheese spacebones/postgres
docker run -d --volumes-from-boneyard --name tuna spacebones/postgres
docker run -d --volumes-from-boneyard --name bacon spacebones/postgres
docker ps 
docker volume list
docker inspect bacon


##7 
#Create a network link between the two Docker containers, spacebones:thewebsite & treatlist 
#using legacy Docker links. Use the image found at spacebones/postgres to create the database.
# Create the SpaceBones Container
docker run -d -p 80:80 --name spacebones spacebones/spacebones:thewebsite
# Create the Treatlist Container
docker run -d -P --name treatlist --link spacebones:spacebones spacebones/postgres
# Verify the link works
docker inspect -f "{{ .HostConfig.Links }}" treatlist 


##8 
#Using the details below, create a new Docker network named borkspace 
#using the 192.168.10.0/24 network range, with the gateway IP address 192.168.10.250. 
#Once the borkspace network is created, use it to launch a new app named treattransfer in 
#interactive mode using the spacebones/nyancat:latest. Once the container is running, 
#you should see a live view of Droolidian cadets running to the rescue!
#Create Network
docker network create --driver=bridge --subnet=192.168.10.0/24 --gateway=192.168.10.250 borkspace
# Verify network is created
docker networl ls 
docker network inspect borkspace
# Launch treattransfer container using the borkspace network
docker run -it --name treattransfer --network=borkspace spacebones/nyancat
# Exit the container
CTRL+c


##9 
#For your final task, create a new Docker volume named mission-status on your host machine.
#Please note that as soon as you SSH into your docker server to start the activity, immediately sudo to 
#become the root user in order to complete this activity.
#Once the volume is created, use the docker cli to display the volume mountpoint on your server. 
#Once you have found the mountpoint, drop to root to move contents found under content-dockerquest-spacebones/volumes/ to 
#local vol directory.
#Once this is done, exit root, then start a new container running on port :80 using the base httpd image found in DockerHub, 
#then visit the site in your browser!
# First lets check if the container exists in docker. If it isn't there we need to clone the repo
git clone https://github.com/linuxacademy/content-dockerrequest-spacebones.git 
# Create a Volume
docker volume create missionstatus
# Check the volume
docker volume inspect missionstatus 
# Copy Website Data to the Volume
sudo -i
cp -r /home/cloud_user/content-dockerquest-spacebones/volumes/*
ls /var/lib/docker/volumes/missionstatus/_data/
# Create a Container
docker run -d -p 80:80 --name fishin-mission --mount source=missionstatus,target=/usr/local/apache2/htdocs httpd
# Browse to the Server IP in browser to confirm


##10 
#Log in to your live environment and sudo to root. Edit the syslog config file and uncomment the two lines 
#under Provides UDP syslog reception. Then, start the syslog service.
#Configure Docker to use syslog as the default log driver and then start the Docker service.
#Create two new containers using the httpd image. The first one will be called syslog-logging and will 
#use syslog for the log driver. The second will be called json-logging and will use the JSON file for the log driver.
#Verify that the syslog-logging container is sending its logs to syslog by running tail on the message log file. Then, 
#verify that the json-logging container is sending its logs to the JSON file.
vi /etc/rsyslog.conf
#uncomment the two lines under `Provides UDP syslog reception` by removing `#`
#$ModLoad imudp
#$UDPServerRun 514
# Start the syslog service
systemctl start syslog 
# Configure Docker to use syslog as the default logging driver - create a file called daemon.json
mkdir /etc/docker 
vi /etc/docker/daemon.json
# Add the following to the json file and save
{
  "log-driver": "syslog",
  "log-opts": {
    "syslog-address": "udp://<PRIVATE_IP>:514"
  }
}
# Restart Docker service
systemctl start docker 
# Create first container
docker container run -d --name syslog-logging httpd
docker ps
docker logs syslog-logging
tail /var/log/messages 
# Create second container
docker container run -d --name json-logging --log-driver json-file httpd 
docker ps
# Verify json-logging container is sending logs to the JSON file
docker logs json-logging 
# Confirm you don't see output in /var/log/messages


##11
#Create the Dockerfile
#The base image should be node.
#Using the RUN instruction, make a directory called /var/node.
#Use the ADD instruction to add the contents of the code directory into /var/node.
#Make /var/node the working directory.
#Execute an npm install.
#Set ./bin/www as the command.
#From the command line, log in to Docker Hub.
#Build your image using <USERNAME>/express.
#Push the image to Docker Hub.
#Create the demo app
#Create a Docker container called demo-app.
#The port mapping should be port 80 on the host, mapping to 3000 on the container.
#The restart policy should be set to always.
#Use the image that you created, <USERNAME>/express.
#Create the Watchtower container
#Create a Docker container called watchtower.
#The restart policy should be set to always.
#Use the -v flag to set /var/run/docker.sock:/var/run/docker.sock.
#Use the v2tec/watchtower followed by the -i flag to set the iteration to 30 seconds.
#Update the Docker image
#Add an instruction to create /var/test. This should be done after creating /var/node.
#Rebuild your image.
#Push the image to Docker Hub.
#Watchtower will update demo-app
#The Watchtower interval is set to 30 seconds.
#After about 30 seconds, check to see if the container has been updated by executing docker ps.
# Create Dockerfile
FROM node

RUN mkdir -p /var/node
ADD content-express-demo-app/ /var/node/
WORKDIR /var/node
RUN npm install 
CMD ./bin/www
# Save the Dockerfile
# Login to docker hub
docker login
# Build the docker image
docker build -t akbaraziz/express -f Dockerfile .
# Push the image to docker hub
docker push akbaraziz/express
# Create the demo container
docker run -d --name demo-app -p 80:3000 --restart always akbaraziz/express 
docker ps 
# Create the watchtower container
docker run -d --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock v2tec/watchtower -i 30
docker ps
# Update Docker Image
# Edit the existing Dockerfile
FROM node

RUN mkdir -p /var/node
RUN mkdir -p /var/test 
ADD content-express-demo-app/ /var/node/
WORKDIR /var/node 
RUN npm install 
CMD ./bin/www 
# Save the Dockerfile
# Rebuild the image
docker build -t akbaraziz/express -f Dockerfile .
# Push to docker hub
docker push akbaraziz/express
# The -i 30 is ther interval watchtower will check for updates every 30 seconds


##12
#In this lab, you will deploy a container that uses labels. In order to complete this Labels, you will need a Docker Hub account.
#Log in to your Docker workstation and Docker server, and sudo to root. 
#You will create the Dockerfile and image on the Docker workstation. 
#The weather-app container will be run on your Docker server.
#Create the Dockerfile
#The base image should be node.
#Add three arguments:
#BUILD_VERSION
#BUILD_DATE
#APPLICATION_NAME
#Add three labels:
#org.label-schema.build-date (will be set using the BUILD_DATE argument)
#org.label-schema.application (will be set using the APPLICATION_NAME argument)
#org.label-schema.version (will be set using the BUILD_VERSION argument)
#Using the RUN instruction, make a directory called /var/node.
#Use the ADD instruction to add the contents of the code directory into /var/node.
#Make /var/node the working directory.
#Execute an npm install.
#Expose port 3000.
#Set ./bin/www as the command.
#From the command line, log in to Docker Hub.
#Build your image using <USERNAME>/weather-app, and supply the following three build arguments:
#BUILD_DATE should be set to $(date -u +'%Y-%m-%dT%H:%M:%SZ').
#APPLICATION_NAME should be set to weather-app.
#BUILD_VERSION should be set to v1.0.
#Push the image to Docker Hub.
#Create the Weather App
#Create a Docker container called weather-app.
#The port mapping should be port 80 on the host, mapping to 3000 on the container.
#The restart policy should be set to always.
#Use the image you created, <USERNAME>/weather-app.
#Use the docker inspect command with the filter flag to filter output for {{.Config.Labels}}.
#Update the Weather App to Version 1.1
#Change directories to /root/weather-app.
#Check out branch v1.1.
#Change directories back to /root.
#Rebuild your image with the following build arguments:
#BUILD_DATE should be set to $(date -u +'%Y-%m-%dT%H:%M:%SZ').
#APPLICATION_NAME should be set to weather-app.
#BUILD_VERSION should be set to v1.1.
#Push the image to Docker Hub.
#Watchtower Will Update weather-app
#The Watchtower interval is set to 5 seconds. After about 10 or 15 seconds, check to see if weather-app has been updated by executing docker ps.
#Use the docker inspect command to see if the version is set to v1.1.
# Create a Dockerfile
FROM node

LABEL maintainer="akbaraziz@yahoo.com"

ARG BUILD_VERSION
ARG BUILD_DATE
ARG APPLICATION_NAME

LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.application=$APPLICATION_NAME
LABEL org.label-schema.version=$BUILD_VERSION

RUN mkdir -p /var/node
ADD weather-app/ /var/node/
WORKDIR /var/node
RUN npm install
EXPOSE 3000
CMD ./bin/www
# Save the file
# Build the image
docker build -t akbaraziz/weather-app --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
--build-arg APPLICATION_NAME=weather-app --build-arg BUILD_VERSION=1.0 -f Dockerfile .
# Show Image ID
docker images 
docker inspect <IMAGE_ID>
# Push to docker hub
docker push akbaraziz/weather-app
# Start the Weather App Container
docker run -d --name demo-app -p 80:3000 --restart always akbaraziz/weather-app
docker ps
# Check out version 1.1 of the weather app
cd weather-app
git checkout v1.1
git branch 
cd ../
# Rebuild the weather-app image
docker build -t akbaraziz/weather-app --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
--build-arg APPLICATION_NAME=weather-app --build-arg BUILD_VERSION=v1.1  -f Dockerfile .
docker inspect <IMAGE_ID>
docker push akbaraziz/weather-app
# Show image status on Docker server
docker ps 
# Inspect Weather-App
docker inspect <IMAGE_ID>


##13
#In this lab, you will load balance containers using two methods. First, you will use Nginx to load balance traffic to three weather-app containers. Next, you will use Docker Swarm to load-balance a pair of Nginx containers.
#Log in to Swarm Server 1 and Swarm Server 2 and sudo su - to root.
#
#Part 1
#We will be using Docker Compose to set up the load balancer and containers.
#On Swarm Server 1, in the root directory, navigate to lb-challenge and create the Docker Compose file.
#Set the Compose version to 3.2.
#Create three weather-app services:
#weather-app1
#weather-app2
#weather-app3
#The services should build the Dockerfile that is in the weather-app directory.
#All three should have tty set to true.
#All three containers should be using the frontend network.
#Create a service called loadbalancer.
#It should use the Dockerfile located in the load-balancer directory.
#Set tty to true.
#The port mapping should be set to 80 on the host and 80 on the container.
#The load balancer should be using the frontend network.
#Create the Frontend Network
#In the load-balancer directory, there will be a file called nginx.conf.
#Add the three weather-app services to the upstream section.
#In the server section, make sure it is listening on port 80.
#Set the server_name to localhost.
#The location should be set to /.
#The location should contain a proxy pass to localhost.
#The proxy set header should be set to $host.
#Execute a compose up and make sure to use the build and detached flags.
#Verify that your app is up and running.
#
#Part 2
#In the root directory, use cat to retrieve the contents of swarm-token.txt.
#Use the docker swarm join --token command from the output of the file to join Swarm Server 2 to the swarm.
#Create a service called nginx-app.
#The published port should be 8080 and the target port should be 80 on the container.
#Make sure there are 2 replicas.
#Use the nginx image.
#Verify that your app is up and running.
vi docker-compose.yml
#Contents of file
version: '3.2'
 services:
   weather-app1:
       build: ./weather-app
       tty: true
       networks:
        - frontend
   weather-app2:
       build: ./weather-app
       tty: true
       networks:
        - frontend
   weather-app3:
       build: ./weather-app
       tty: true
       networks:
        - frontend

   loadbalancer:
       build: ./load-balancer
       image: nginx
       tty: true
       ports:
        - '80:80'
       networks:
        - frontend

 networks:
   frontend:
#Save the file
# Edit the nginx.conf file
events { worker_connections 1024; }

 http {
   upstream localhost {
     server weather-app1:3000;
     server weather-app2:3000;
     server weather-app3:3000;
   }
   server {
     listen 80;
     server_name localhost;
     location / {
       proxy_pass http://localhost;
       proxy_set_header Host $host;
     }
   }
 }
 #Execute Docker Compose Up
 docker-compose up --build -d
 docker ps
 #Copy the public IP address of Swarm Server 1
 #Create a Docker Service using Docker Swarm
 cat swarm-token.txt 
 #Copy the docker join command from the previous step
 #On Swarm Server 2
 #On Swarm Server 1
 docker service create --name nginx-app --publish published=8080,target=80 --replicas=2 nginx
 docker ps 
 PUBLIC_IP_ADDRESS:8080


##14 
#In this hands-on lab, we will create a Ghost Blog service using Docker Compose.
#Log in to the live environment and sudo to root.
#Create a Docker Compose file in the root directory of your live environment. You will create two services: a Ghost Blog service and a MySQL service.
#Set the Compose version to 3.
#Create your first service called ghost.
#Use the ghost:1-alpine image.
#Call the container ghost-blog.
#You will use five environment variables:
#Set database__client to mysql.
#Set database__connection__host to mysql.
#Set database__connection__user to root.
#Set database__connection__password to P4sSw0rd0!
#Set database__connection__database to ghost.
#Create a volume called ghost-volume and map it to /var/lib/ghost.
#Map port 80 on the host to port 2368 on the container.
#The ghost_blog container will be dependent on the mysql container.
#Make sure that the container always restarts.
#Create a second service called mysql.
#Use the mysql:5.7 image.
#Name the container ghost-db.
#You will add the following environment variable:
	#Set MYSQL_ROOT_PASSWORD to P4sSw0rd0!
#Create a volume called mysql-volume and map it to /var/lib/mysql.
#Make sure that the container always restarts.
#Make sure that the two volumes are called ghost-volume and mysql-volume.
#Execute a compose up and make sure to use the detached flag.
#Verify that your app is up and running.
#Set MYSQL_ROOT_PASSWORD to P4sSw0rd0!
#Create a volume called mysql-volume and map it to /var/lib/mysql.
#Make sure that the container always restarts.
#Make sure that the two volumes are called ghost-volume and mysql-volume.
#Execute a compose up and make sure to use the detached flag.
#Verify that your app is up and running.
vi docker-compose.yml 
version: '3'
 services:
   ghost:
     image: ghost:1-alpine
     container_name: ghost-blog
     restart: always
     ports:
       - 80:2368
     environment:
       database__client: mysql
       database__connection__host: mysql
       database__connection__user: root
       database__connection__password: P4sSw0rd0!
       database__connection__database: ghost
     volumes:
       - ghost-volume:/var/lib/ghost
     depends_on:
       - mysql

   mysql:
     image: mysql:5.7
     container_name: ghost-db
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: P4sSw0rd0!
     volumes:
       - mysql-volume:/var/lib/mysql

 volumes:
   ghost-volume:
   mysql-volume:
# Bring up the Ghost Blog Service
docker-compose up -d


##15
