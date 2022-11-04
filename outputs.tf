output "instance_ami" {
  value = aws_instance.ant_media_ec2[0].ami
}

output "instance_arn" {
  value = aws_instance.ant_media_ec2[0].arn
}

output "instance_username" {
  value = "JamesBond"
}

output "instance_password" {
  value = aws_instance.ant_media_ec2[*].id
}

output "instance_ip" {
  value = aws_instance.ant_media_ec2[*].public_ip
}

output "alb_domain" {
  value = aws_lb.ant_media_alb.dns_name
}