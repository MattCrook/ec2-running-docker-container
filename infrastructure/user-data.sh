#! /bin/sh
yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
sudo apt-get install jq

docker pull mgcrook11/webserver-node-app:${release_version}
docker run -it -d --name webserver-app -p ${http_port}:${http_port} mgcrook11/webserver-node-app:${release_version}
