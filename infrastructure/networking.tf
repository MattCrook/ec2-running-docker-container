# Creating a (basic/default) VPC for the EC2 instance to reside in.
resource "aws_vpc" "default" {
    cidr_block           = "10.0.0.0/16"
    instance_tenancy     = "default"
    enable_dns_hostnames = true

    tags = {
        Name = "fairwinds-code-challenge-default-vpc"
    }
}

# The Internet Gateway allows resources (In this project the EC2) within the VPC to access the internet, and vice versa.
# In order for this to happen, there needs to be a routing table entry allowing a subnet to access the IGW.
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.default.id

    tags = {
        Name = "fairwinds-code-challenge-default-IGW"
    }
}

# Creating a public subnet. For demo purposes and in light of saving resouce consuption and time,
# I am only creating a public subnet, however in a normal situation would create a private subnet as well.
# That private subnet having its own routing table, and the route table for the public subnet would have access to the Internet Gateway as well as the private subnet.
# In Addition, with a private subnet there would need to be a NAT Gateway, to allow outbound traffic from within the private subnet, as well as an EIP (Elastic IP),
# which serves as the public IP for the NAT Gateway.
resource "aws_subnet" "subnet" {
    vpc_id                  = aws_vpc.default.id
    cidr_block              = "10.0.0.0/24"
    map_public_ip_on_launch = true

    depends_on = [aws_internet_gateway.IGW]

    tags = {
        Name = "fairwinds-code-challenge-default-subnet"
    }
}

resource "aws_route_table" "PublicRT" {
    vpc_id =  aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
}

# Route table Association with Public Subnet.
resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id      = aws_subnet.subnet.id
    route_table_id = aws_route_table.PublicRT.id
 }
