data "template_file" "user_data" {
  template = file("user-data.sh")

  vars = {
    public_ip = "FooBar"
    server_port  = var.server_port
  }
}




// Directs TF to look up the Default VPC in your AWS account.
// data "aws_vpc" "default" {
//     default = true
// }

// // Look up the subnets within your VPC.
// data "aws_subnet_ids" "default" {
//     vpc_id = data.aws_vpc.default.id
// }



// data "aws_ami" "ubuntu" {
//   most_recent = true

//   filter {
//     name   = "name"
//     values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
//   }

//   filter {
//     name   = "virtualization-type"
//     values = ["hvm"]
//   }

//   owners = ["099720109477"]
// }
