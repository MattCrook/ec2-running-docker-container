#!/bin/bash

cd ..
cd infrastructure
terraform init
echo "Running Terraform Plan"
terraform plan

retVal=$?

if [ $retVal -eq 1 ]; then
    echo "Terraform plan failed"
else
    echo "Terraform plan is clean. Do you wish to apply? (y/n)"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
    echo "Running Terraform apply"
    terraform apply
    if [ $retVal -eq 1 ]; then
        public_ip=terraform output public_ip
        port=8080

        ssh -i "webserver_key.pem" ec2-user@ec2-$public_ip.eu-west-3.compute.amazonaws.com
        docker pull mgcrook11/webserver-node-app:1.1
        docker run -it -d --name webserver-app -p 8080:8080 mgcrook11/webserver-node-app:1.1
        exit
    echo "Opening Fairwinds Code Challenge demo app on http://${public_ip}:${port}"
    sleep 2
    xdg-open http://$public_ip:$port
    fi

    else
        echo "Exiting..."
    fi
fi
