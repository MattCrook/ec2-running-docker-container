resource "aws_vpc" "default" {
    cidr_block           = "10.0.0.0/16"
    instance_tenancy     = "default"
    enable_dns_hostnames = true

    tags = {
        Name = "fairwinds-code-challenge-default-vpc"
    }
}

# An Internet Gateway allows resources within your VPC to access the internet, and vice versa.
# In order for this to happen, there needs to be a routing table entry allowing a subnet to access the IGW.
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.default.id

    tags = {
        Name = "fairwinds-code-challenge-default-IGW"
    }
}

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
        # Traffic from Public Subnet reaches Internet via Internet Gateway
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
}

# Route table Association with Public Subnet's
resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id      = aws_subnet.subnet.id
    route_table_id = aws_route_table.PublicRT.id
 }
