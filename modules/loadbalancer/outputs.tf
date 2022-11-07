output "alb_domain" {
  value = aws_lb.ant_media_alb.dns_name
}

output "nlb_domain" {
  value = aws_lb.ant_media_nlb.dns_name
}