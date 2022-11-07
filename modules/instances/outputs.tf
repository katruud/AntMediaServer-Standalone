output "instance_ami" {
  value = aws_instance.ant_media_ec2[0].ami
}

output "instance_arn" {
  value = aws_instance.ant_media_ec2[0].arn
}

output "instance_username" {
  value = "JamesBond"
}

output "instance_ip" {
  value = aws_instance.ant_media_ec2[*].public_ip
}

output "instance_id" {
  value = aws_instance.ant_media_ec2[*].id
}