#!/bin/bash

cd ..
cd infrastructure
terraform init
echo "Running Terraform destroy"
sleep 2
terraform destroy
