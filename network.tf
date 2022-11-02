# VPC
# 
resource "aws_vpc" "ant_media_vpc" {
  cidr_block = var.vpc_cidr

    tags = {
    Name = "ant media vpc"
  }
}

# Subnet
resource "aws_subnet" "ant_media_subnet" {
  vpc_id     = aws_vpc.ant_media_vpc.id
  cidr_block = var.vpc_cidr
  availability_zone = var.az
  map_public_ip_on_launch = true
  
  tags = {
    Name = "ant media subnet"
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
 subnet_id      = aws_subnet.ant_media_subnet.id
 route_table_id = aws_route_table.ant_media_route.id
}