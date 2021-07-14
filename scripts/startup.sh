#!/bin/bash

#set -e

cd infrastructure
terraform init
echo "Running Terraform Plan"
terraform plan

retVal=$?

if [ $retVal -eq 1 ]; then
    echo "Terraform plan failed"
    exit 1
else
    echo "Terraform plan is clean. Do you wish to apply? (y/n)"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
        echo "Running Terraform apply"
        terraform apply
        if [ $? -eq 1 ]; then
            echo "Problem with Terraform apply."
            exit 1
        else
            echo "Terraform apply is clean."
        fi
    else
        echo "Exiting..."
        exit 1
    fi
fi

PUBLIC_IP=$(terraform output -json public_ip | jq -r '.')
PUBLIC_DNS=$(terraform output -json public_dns | jq -r '.')
WEBSERVER_ARN=$(terraform output -json webserver_arn | jq -r '.')
PORT=8080
KEY=webserver_key.pem

if [ -n $PUBLIC_IP ]; then
    chmod 400 $KEY
fi

CYAN='\033[1;36m'
LIGHTBLUE='\033[1;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Reads "until curl successfully completes the requested transfer, wait 3 seconds and retry".
# -s prevents it from printing messages and the progress meter,
# -o /dev/null assumes you are not interested in the content of the response.
# -L follow redirects
# -w Use output FORMAT after completion
wait-for-boot-up() {
    echo "Testing $1"
    while [[ "$(curl -s -o /dev/null -L -w ''%{http_code}'' ${1})" != "200" ]]; do
      echo -e "${YELLOW}Waiting for ${WEBSERVER_ARN}${NC}"
      sleep 4
    done
    echo -e "${GREEN}OK!${NC}"
    curl -I $1
}

echo -e "${CYAN}The demo Express app will be available on http://${PUBLIC_IP}:${PORT}${NC}"
sleep 2
echo "The instance may take a couple seconds to boot up the application..."
sleep 5
echo "If you wish to check that Docker is running manually, you can run the following command to ssh onto your EC2 instance:"
sleep 2
echo -e "${CYAN}cd infrastructure && ssh -i ${KEY} ec2-user@${PUBLIC_DNS}${NC}"
sleep 2

wait-for-boot-up http://${PUBLIC_IP}:${PORT}
sleep 4

echo -e "Opening Webserver-app on http://${PUBLIC_IP}:${PORT}"
sleep 2

open http://$PUBLIC_IP:$PORT
