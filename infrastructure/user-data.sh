#! /bin/sh
yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
sudo apt-get install jq

docker pull mgcrook11/webserver-node-app:1.1
docker run -it -d --name webserver-app -p 8080:8080 mgcrook11/webserver-node-app:1.1
