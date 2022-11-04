# VPC
resource "aws_vpc" "ant_media_vpc" {
  cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
    Name = "ant media vpc"
  }
}

# Subnets
resource "aws_subnet" "ant_media_private_subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.ant_media_vpc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.az, count.index)
  map_public_ip_on_launch = false
  
  tags = {
    Name = "ant media private subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "ant_media_public_subnet" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.ant_media_vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.az, count.index)
  map_public_ip_on_launch = false
  
  tags = {
    Name = "ant media public subnet ${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ant_media_gw" {
  vpc_id = aws_vpc.ant_media_vpc.id

  tags = {
    Name = "ant media gateway"
  }
}

# Route table and association 
resource "aws_route_table" "ant_media_route" {
 vpc_id = aws_vpc.ant_media_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.ant_media_gw.id
 }
 
 tags = {
   Name = "ant media route table"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.ant_media_public_subnet[*].id, count.index)
 route_table_id = aws_route_table.ant_media_route.id
}