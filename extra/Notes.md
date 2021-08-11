## Notes

```
npm init -y
npm i -D nodemon

npm i pug
npm i -D browser-sync
browser-sync init

docker build -t webserver-app .

docker tag webserver-app:latest mgcrook11/webserver-node-app:1.2
docker push mgcrook11/webserver-node-app:1.2

chmod 400 webserver_key.pem
ssh -i "webserver_key.pem" ec2-user@ec2-18-233-63-64.compute-1.amazonaws.com

ssh -i "webserver_key.pem" ec2-user@ec2-13-36-235-21.eu-west-3.compute.amazonaws.com



docker pull mgcrook11/webserver-node-app:1.1

docker run -it -d -n webserver-app -p 8080:8080 webserver-node-app:1.1

docker run -it -d --name webserver-app -p 80:8080 mgcrook11/webserver-node-app:1.1


aws ec2 describe-availability-zones --region eu-west-3

Start terraform 
    terraform init
    terraform plan (if all good continue)
    terraform apply

Start docker in EC2
    ssh into VM
    run docker pull
    run docker run


Creates a VPC
Creates an Internet Gateway and attaches it to the VPC to allow traffic within the VPC to be reachable by the outside world.
Creates a public and private subnet
Subnets are networks within networks. They are designed to help network traffic flow be more efficient and provide smaller, more manageable ‘chunks’ of IP addresses
Creates a route table for the public and private subnets and associates the table with both subnets
Creates a NAT Gateway to enable private subnets to reach out to the internet without needing an externally routable IP address assigned to each resource.


sudo apt-get install jq
brew install jq
chmod +x jq
```
