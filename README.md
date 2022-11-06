# Ant Media Server Standalone Deployment

This is an example Terraform configuration which will deploy [Ant Media Server Enterprise for ARM](https://aws.amazon.com/marketplace/pp/prodview-s72grshttriy4) to your AWS account

Currently, this will create:
- An ALB which will route HTTP and HTTPS traffic
- A c6g.large instance with AMS installed
- Security groups to restrict access to required ports
- A custom VPC/network you can configure in variables.tf

AWS credentials must be supplied to your Terraform environment