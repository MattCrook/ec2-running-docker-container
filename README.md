# Technical Challenge

This project creates an EC2 instance running a basic web application in Docker using a single command from the user. Before the script is run, there is no EC2 instances running and afterward the script should output the address of your working web application. The single command from the user can (and likely will) call a longer shell script, or other configuration management code. Part of the challenge is to have restricted access, so you can not use to EKS, ECS, S3, ELB, ASG, or Route53.




Run:
* `chmod 0755 app_up.sh && chmod 0755 app_down.sh`

To start the build and run the app:
  * `./app_up.sh`

When finished, to tear everything down:
* `./app_down.sh`
