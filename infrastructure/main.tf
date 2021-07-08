terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "eu-west-3"
}

locals {
  # Specifying port 8080 here rather than default port 80 as that any port less than 1024 requires root user privileges. This is a security risk.
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
    ami                         = "${var.ami}"
    instance_type               = "${var.instance_type}"
    vpc_security_group_ids      = [aws_security_group.allow_all_inbound.id, aws_security_group.allow_all_outbound.id, aws_security_group.allow_ssh.id]
    key_name                    = aws_key_pair.webserver_key.key_name
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.subnet.id
    user_data                   = data.template_file.user_data.rendered
    monitoring                  = true

    tags = {
        env = "dev"
        Name = "webserver"
    }
}

resource "aws_security_group" "allow_all_inbound" {
    name        = "web-app-instance-security-group-inbound"
    vpc_id      = aws_vpc.default.id

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
    name        = "web-app-instance-security-group-outbound"
    vpc_id      = aws_vpc.default.id

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
    name        = "web-app-instance-security-group-ssh"
    vpc_id      = aws_vpc.default.id

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
