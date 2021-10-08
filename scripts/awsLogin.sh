#!/bin/bash

LIGHTBLUE='\033[1;34m'
YELLOW='\033[1;33m'
LIGHTRED='\033[1;31m'
RED='\033[0;31m'
LIGHTYELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m'
CURRENT_PROFILE=$(aws sts get-caller-identity)


echo ""
echo "Your current AWS profile is: "
echo -e "${LIGHTBLUE}${CURRENT_PROFILE} ${NC}"

function main() {
    echo ""
    echo "AWS Login: "

    echo "  1. List Configurations"
    echo "  2. List Profiles"
    echo "  3. Configure Profile"
    echo "  4. Get Availability Zones"
    echo "  5. Get sts caller identity"
    echo " "
    echo -e "  ${LIGHTYELLOW}Extra${NC}: "
    echo "  6.  Get IAM Authorization Details"
    echo "  7.  Get IAM Account Summary"
    echo "  8.  Get IAM Get Login Profile"
    echo "  9.  Get IAM Get Credential Report"
    echo "  10. Get IAM Get User"
    echo "  11. Get IAM Get SSH Public Key"
    echo "  12. Get IAM Get User Policy"
    echo "  13. Get IAM Get Access Key Info (Get AWS Account)"
    echo -e "  ${LIGHTRED}14. Exit${NC}"

    echo ""
    echo "Enter number of option: "

    read option

    if [ "$option" == "1" ]; then
        aws configure list

    elif [ "$option" == "2" ]; then
        aws configure list-profiles

    elif [ $option == "3" ]; then
        aws configure

    elif [ $option == "4" ]; then
        describe-availability-zones

    elif [ $option == "5" ]; then
        get-caller-identity

    elif [ $option == "6" ]; then
        aws iam get-account-authorization-details

    elif [ $option == "7" ]; then
        aws iam get-account-summary

    elif [ $option == "8" ]; then
        echo "Enter username: "
        read username
        aws iam get-login-profile --user-name $username

    elif [ $option == "9" ]; then
        aws iam get-credential-report

    elif [ $option == "10" ]; then
        aws iam get-user

    elif [ $option == "11" ]; then
        aws iam get-ssh-public-key

    elif [ $option == "12" ]; then
        echo "Enter Username: "
        read username
        echo "Enter Policy Name: "
        read policy_name
        aws iam get-user-policy --user-name $username --policy-name $policy_name

    elif [ $option == "13" ]; then
        aws sts get-access-key-info --access-key-id $AWS_ACCESS_KEY_ID

    elif [ $option == "14" ]; then
        exit 0
    fi
}


function describe-availability-zones() {
    echo "Input region (e.g us-east-1): "
    read region
    aws ec2 describe-availability-zones --region $region
}

function get-caller-identity() {
  if [ $? -eq 1 ]; then
    echo "Getting caller Identity failed, please put your AWS credentials in your environment, in your PATH, or in your ~./aws/credentials file."
    echo "Example: "
    echo "export AWS_ACCESS_KEY_ID='your_access_key'"
    echo "export AWS_SECRET_ACCESS_KEY='your_secret_key'"
    exit 1
  else
    aws sts get-caller-identity
    CURRENT_PROFILE=$(aws sts get-caller-identity)
  fi
}


main
