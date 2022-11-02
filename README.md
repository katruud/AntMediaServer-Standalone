# Ant Media Server Standalone Deployment

This is an example Terraform configuration which will deploy [Ant Media Server Enterprise for ARM](https://aws.amazon.com/marketplace/pp/prodview-s72grshttriy4) to your AWS account

Currently, this will create:
- A c6g.large instance with AMS installed
- A security group only accessable via an IP you specify
- A custom VPC/network you can configure in variables.tf

AWS credentials must be supplied to your Terraform environment