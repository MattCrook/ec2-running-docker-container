output "public_ip" {
    value       = aws_instance.webserver.public_ip
    description = "The pubic IP address of the web server"
}

output "webserver_arn"{
    value       = aws_instance.webserver.arn
    description = "AMI ARN of the virtual machine"
}

// output "aws_subnet_ids" {
//     value = data.aws_vpc.default.id
// }
