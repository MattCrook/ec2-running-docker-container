#!/bin/bash

cd ..
cd infrastructure
terraform init
echo "Running Terraform Plan"
#terraform plan

#retVal=$?
retVal=0

if [ $retVal -eq 1 ]; then
    echo "Terraform plan failed"
else
    echo "Terraform plan is clean. Do you wish to apply? (y/n)"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
        echo "Running Terraform apply"
        terraform apply
        if [ $? -eq 1 ]; then
            echo "Problem with Terraform apply."
        else
            echo "Terraform apply is clean."
        fi
    else
        echo "Exiting..."
    fi
fi


PUBLIC_IP=$(terraform output -json public_ip | jq -r '.')
PUBLIC_DNS=$(terraform output -json public_dns | jq -r '.')
PORT=8080
KEY=webserver_key.pem
echo "${PUBLIC_IP}"

# if [ -n $PUBLIC_IP ]; then
#     chmod 400 $KEY
#     ssh -i "webserver_key.pem" ec2-user@"${PUBLIC_DNS}"
#     docker pull mgcrook11/webserver-node-app:1.1
#     docker run -it -d --name webserver-app -p 8080:8080 mgcrook11/webserver-node-app:1.1
#     EXITEC2=$(exit)
#     $EXITEC2
# else
#     echo "Problem getting Terraform outputs"
# fi

echo "Opening Fairwinds Code Challenge demo app on http://${PUBLIC_IP}:${PORT}"
sleep 2
xdg-open http://$PUBLIC_IP:$PORT
google-chrome http://$PUBLIC_IP:$PORT
open http://$PUBLIC_IP:$PORT
