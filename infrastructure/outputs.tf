output "public_ip" {
    value       = "${aws_instance.webserver.public_ip}"
    description = "The pubic IP address of the web server"
}

output "public_dns" {
    value       = "${aws_instance.webserver.public_dns}"
    description = "The public DNS name assigned to the instance."
}

output "primary_network_interface_id" {
    value       = "${aws_instance.webserver.primary_network_interface_id}"
    description = "The ID of the instance's primary network interface"
}

output "webserver_arn"{
    value       = "${aws_instance.webserver.arn}"
    description = "AMI ARN of the virtual machine"
}

// output "aws_subnet_ids" {
//     value = data.aws_vpc.default.id
// }
