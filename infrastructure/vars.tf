variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 8080
}

# Defining the CIDR block use 10.0.0.0/24 for this code challenge demo
variable "main_vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/24"
}

variable "public_subnets" {
    description = "The CIDR block for the subnet."
    type        = string
    default     = "10.0.0.128/26"
}

variable "private_subnets" {
    description = "The CIDR block for the subnet."
    type        = string
    default     = "10.0.0.192/26"
}
