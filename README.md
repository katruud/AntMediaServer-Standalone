# Ant Media Server Standalone Deployment

This is an example Terraform configuration which will deploy [Ant Media Server Enterprise](https://aws.amazon.com/marketplace/pp/prodview-464ritgzkzod6) to your AWS account

Currently, this will create:
- A c5.large instance with AMS installed
- A security group only accessable via an IP you specify

AWS credentials must be supplied to your Terraform environment