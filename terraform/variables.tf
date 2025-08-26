variable "aws_region" { default = "us-east-1" }
variable "vpc_id" { type = string }
variable "vpc_cidr" { default = "172.31.0.0/16" }
variable "cluster_name" { default = "prod-k8s-cluster" }
variable "key_name" { type = string }