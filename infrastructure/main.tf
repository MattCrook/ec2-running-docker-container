terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}

locals {
  # Specifying port 8080 here rather than default port 80 is that any port less than 1024 requires root user privileges. This is a security risk.
  http_port     = 8080
  any_port      = 0
  any_protocol  = "-1"
  tcp_protocol  = "tcp"
  http_protocol = "http"
  all_ips       = ["0.0.0.0/0"]
}

resource "tls_private_key" "webserver_private_key" {
   algorithm = "RSA"
   rsa_bits = 4096
}

resource "local_file" "private_key" {
   content = tls_private_key.webserver_private_key.private_key_pem
   filename = "webserver_key.pem"
   file_permission = 0400
}

resource "aws_key_pair" "webserver_key" {
   key_name = "webserver"
   public_key = tls_private_key.webserver_private_key.public_key_openssh
}




resource "aws_instance" "webserver" {
    # base ubuntu image
    # ami                    = "ami-0d66ad041b3973276"
    ami                    = "ami-0ab4d1e9cf9a1215a"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_all_inbound.id, aws_security_group.allow_all_outbound.id, aws_security_group.allow_ssh.id]
    key_name               = aws_key_pair.webserver_key.key_name
    user_data              = data.template_file.user_data.rendered
    # With amazon linux image
    // user_data = <<-EOF
    //     #!/bin/bash
    //     sudo yum update -y
    //     sudo yum install httpd -y
    //     sudo service httpd start
    //     sudo chkconfig httpd on
    //     echo "<html><h1>Your terraform deployment worked !!!</h1></html>" | sudo tee /var/www/html/index.html
    //     hostname -f >> /var/www/html/index.html
    //     EOF
    # Need to tell Terraform to use SSH to connect to this EC2 instance when running the remote-exec provisioner.
    // connection {
    //     type        = "ssh"
    //     host        = self.public_ip
    //     user        = "ec2-user"
    //     private_key = tls_private_key.webserver_private_key.private_key_pem
    //     port        = 22
    // }

    // provisioner "remote-exec" {
    //     inline = [
    //         "docker pull mgcrook11/webserver-node-app:1.0",
    //         "docker run -it -d -p 8080:8080 mgcrook11/webserver-node-app:1.0"
    //         ]
    // }

    tags = {
        env = "dev"
        Name = "webserver"
    }
}

resource "aws_security_group" "allow_all_inbound" {
    name = "web-app-instance-security-group-inbound"

    ingress {
        description = local.http_protocol
        from_port   = local.http_port
        to_port     = local.http_port
        protocol    = local.tcp_protocol
        cidr_blocks = local.all_ips
    }

    tags = {
        Name = "allow_inbound"
    }
}

resource "aws_security_group" "allow_all_outbound" {
    name = "web-app-instance-security-group-outbound"


    egress {
        from_port   = local.any_port
        to_port     = local.any_port
        protocol    = local.any_protocol
        cidr_blocks = local.all_ips
    }

    tags = {
        Name = "allow_outbound"
    }
}

resource "aws_security_group" "allow_ssh" {
    name = "web-app-instance-security-group-ssh"

    ingress {
        description = "ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_ssh"
    }
}



// resource "aws_security_group" "allow_http_ssh" {
//     name        = "allow_http"
//     description = "Allow http inbound traffic"

//     ingress {
//         description = "http"
//         from_port   = 80
//         to_port     = 80
//         protocol    = "tcp"
//         cidr_blocks = ["0.0.0.0/0"]
//     }

//     ingress {
//         description = "ssh"
//         from_port   = 22
//         to_port     = 22
//         protocol    = "tcp"
//         cidr_blocks = ["0.0.0.0/0"]
//     }

//     egress {
//         from_port   = 0
//         to_port     = 0
//         protocol    = "-1"
//         cidr_blocks = ["0.0.0.0/0"]
//     }

//     tags = {
//         Name = "allow_http_ssh"
//     }
// }
