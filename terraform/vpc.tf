# terraform/vpc.tf

# A VPC is our isolated network within AWS.
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # Defines the IP address range for our entire network.
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "learnbridge-vpc"
  }
}

# We need subnets in at least two different Availability Zones (AZs) for high availability.
# These are our PUBLIC subnets, meaning they can have a direct route to the internet.
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a" # Change AZ if your region is different
  map_public_ip_on_launch = true

  tags = {
    Name = "learnbridge-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b" # Change AZ if your region is different
  map_public_ip_on_launch = true

  tags = {
    Name = "learnbridge-public-b"
  }
}

# These are our PRIVATE subnets. Our microservices will live here.
# They CANNOT be reached directly from the internet.
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "eu-west-1a" # Change AZ if your region is different

  tags = {
    Name = "learnbridge-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "eu-west-1b" # Change AZ if your region is different

  tags = {
    Name = "learnbridge-private-b"
  }
}

# An Internet Gateway allows resources in our public subnets to communicate with the internet.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "learnbridge-igw"
  }
}

# This route table directs internet-bound traffic from our public subnets to the Internet Gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Represents all internet traffic
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "learnbridge-public-rt"
  }
}

# Associate our public subnets with the public route table.
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}