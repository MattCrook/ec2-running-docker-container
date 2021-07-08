# Technical Challenge

This project creates an EC2 instance running a basic web application in Docker using a single command from the user. Before the script is run, there is no EC2 instances running and afterward the script should output the address of your working web application. The single command from the user can (and likely will) call a longer shell script, or other configuration management code. Part of the challenge is to have restricted access, so you can not use to EKS, ECS, S3, ELB, ASG, or Route53.



## Set Up

### Credentials

You will need an AWS account and AWS credentials in your environment to run this program. Once you have them, put them in your environment like:

```sh
export AWS_ACCESS_KEY_ID="<aws_access_key_id>"
export AWS_SECRET_ACCESS_KEY="<aws_secret_access_key>"
```

### Startup

To run the program which will set up all the necessary infrastructure and run the application, be in the root directory and first run:

* `make prep`

Then, run:

* `make start`

The make target `make start` provides a simple, single command that will then call the `./scripts/startup.sh` script to automate going through the steps necessary to run the terraform to provision the infrastructure, pull the docker image onto the EC2 instance, then start the container. Once completed, you should see a working application in your browser at the IP and port that is output in your console.


## Tear Down

To clean up and tear everything down, be in the root directory and run:

* `make stop`

This will call the `./scripts/teardown.sh` script as a simple way to automate running the appropriate Terraform commands (`terraform destroy`) to tear down and clean up your infrastructure.

## Notes

* The EC2 instance may take up to a minute or two to boot up, so while Terraform has finished provisioning your EC2, and you may see the URL to go to in the output of the the startup program, the EC2 is still may not be ready to receive requests.
  * You will see "Waiting for (`the ARN of your instance`)...
    * This is put in place to continually curl your instance every 3 seconds until it responds with a 200, meaning it has fully booted and is responding to requests. No need to do anything, just wait for the instance to boot, and once it does the script will continue and open a browser tab for you.
