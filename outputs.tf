output "instance_ami" {
  value = aws_instance.ant_media.ami
}

output "instance_arn" {
  value = aws_instance.ant_media.arn
}

output "instance_username" {
  value = "JamesBond"
}

output "instance_password" {
  value = aws_instance.ant_media.id
}

output "instance_ip" {
  value = aws_instance.ant_media.public_ip
}