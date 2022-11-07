output "private_subnet_id" {
  value = aws_subnet.ant_media_private_subnet[*].id
}

output "public_subnet_id" {
  value = aws_subnet.ant_media_public_subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.ant_media_vpc.id
}