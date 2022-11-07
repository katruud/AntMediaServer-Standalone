# Ant Media Server Standalone Deployment

This repository contains modules and configurations for deploying [Ant Media Server Enterprise](https://aws.amazon.com/marketplace/pp/prodview-s72grshttriy4) (AMS) to your AWS account. The standalone configuration refers to the operation of the server in single-instance mode as opposed to AMS's supported [cluster mode](https://antmedia.io/ant-media-server-cluster/). 

This is currently a work in progress, with the end goal of providing a low-latency (from using modern protocols such as SRT and WebRTC), low traffic streaming pipeline for stream composition before delivery to a high-traffic, low cost CDN. An application targeted for this service is virtual music festival productions, such as [OMF](https://tech.orionvr.club/).

<img src="https://raw.githubusercontent.com/katruud/AntMediaServer-Standalone/main/.images/omf_production-stream.png" width="640" height="480">
Example application stream chain

## Modules

Currently, this includes modules for:
- VPC: VPC, subnets, basic networking
- Instances: instance creation and networking assignment
- Load balancer: optional ALB and NLB load balancer 

These are located in the modules folder. The application folder includes sample code for running these modules, resulting in this architecture:
<img src="https://raw.githubusercontent.com/katruud/AntMediaServer-Standalone/main/.images/AMSELB.png" width="640" height="480">

To create, AWS credentials must be supplied to your Terraform environment. The application may also be launched without the load balancers if you wish to assign a public IP directly to the instance.