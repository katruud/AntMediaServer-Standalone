output "instance_ami" {
  value = aws_instance.ant_media_ec2.ami
}

output "instance_arn" {
  value = aws_instance.ant_media_ec2.arn
}

output "instance_username" {
  value = "JamesBond"
}

output "instance_password" {
  value = aws_instance.ant_media_ec2.id
}

output "instance_ip" {
  value = aws_instance.ant_media_ec2.public_ip
}