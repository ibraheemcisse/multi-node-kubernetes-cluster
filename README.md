# Production-Ready Kubernetes Cluster on AWS (Test Project)

![Terraform](https://img.shields.io/badge/Terraform-v1.6-blue?logo=terraform)
![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.29-blue?logo=kubernetes)
![AWS](https://img.shields.io/badge/AWS-Amazon-orange?logo=amazon-aws)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange?logo=ubuntu)

---

## Overview

This repository demonstrates how to deploy a **production-ready Kubernetes cluster** on AWS **from scratch**. It uses EC2 instances, Terraform, user-data scripts, and proper security configurations to simulate a real-world, highly controlled deployment environment.  

Even though this is a **test project**, it mirrors **production best practices**, giving hands-on exposure to the full stack of Kubernetes infrastructure, including networking, security, and container orchestration.

---

## Why This Setup?

Most tutorials focus on "get it working" steps, but real-world Kubernetes deployments require attention to:

- **Security groups**: Proper isolation between control plane, worker nodes, load balancers, and databases  
- **Networking**: BGP setup for Calico to ensure pod-to-pod communication  
- **Container runtime configuration**: SystemdCgroup settings for containerd and kubelet  
- **Reproducibility**: Using Terraform for consistent deployments  

By manually setting up Kubernetes rather than using **AWS EKS**, this project teaches the inner workings of Kubernetes and equips you to troubleshoot real-world issues effectively.

---

## What Makes This Setup Better?

Even as a test project, this setup follows **production-grade best practices**:

1. **Granular Security Control**
   - Separate security groups for control plane, workers, load balancers, and databases  
   - Explicit BGP port access for Calico networking (port 179)  
   - NodePort, Kubelet API, and pod-to-pod communication correctly configured  

2. **Reproducible Infrastructure**
   - Terraform scripts provision VPC, EC2 instances, and security groups  
   - User-data scripts automate container runtime and Kubernetes installation  

3. **High Observability & Debuggability**
   - Cluster designed for troubleshooting common issues like taints, DNS resolution, or kubelet failures  
   - Network and service configurations clearly separated  

4. **Scalable & Flexible Design**
   - Horizontal scaling supported by adding more worker nodes  
   - Pod CIDR and service CIDR ranges allow large deployments  
   - Mirrors production cluster architecture  

---

## Architecture Diagram

```mermaid
graph TD
  A[VPC] --> B[Control Plane (t3.medium)]
  A --> C[Worker Node 1 (t3.small)]
  A --> D[Worker Node 2 (t3.small)]
  B -->|API| C
  B -->|API| D
  C -->|Pod Networking| D
  C -->|Services| ALB[Application Load Balancer]
  D -->|Services| ALB
  C -->|Database Access| DB[Managed Database]
  D -->|Database Access| DB


#!/bin/bash
# Kubernetes Multi-Node Deployment on AWS (Test Project)

# Specifications
# CNI: Calico for BGP-enabled pod networking
# OS: Ubuntu 22.04 LTS
# Container Runtime: containerd with SystemdCgroup = true
# Security: Principle of least privilege; no open access beyond required ports

# Achievements
# Multi-node Kubernetes cluster deployed manually on AWS
# Calico CNI configured for robust pod networking
# Correct security groups for control plane, worker nodes, ALB, and database
# Automated deployment via Terraform and user-data scripts
# Verified pod-to-pod communication, service connectivity, and DNS resolution
# Hands-on troubleshooting of real-world issues like kubelet cgroup mismatches, taints, and BGP connectivity

# Folder Structure
# terraform/
# ├── main.tf             # AWS resource configuration
# ├── variables.tf        # Input variables
# ├── outputs.tf          # Terraform outputs
# └── security_groups.tf  # Security group rules
# userdata/
# ├── master.sh           # Master node setup script
# └── worker.sh           # Worker node setup script
# README.md               # Project documentation
# .gitignore

# Deployment Instructions

# Clone the repository
git clone https://github.com/<your-username>/k8s-aws-production.git
cd k8s-aws-production/terraform

# Initialize Terraform
terraform init

# Review and apply Terraform plan
terraform plan
terraform apply

# SSH into the master node and initialize Kubernetes
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --service-cidr=10.96.0.0/12

# Deploy Calico CNI
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
kubectl wait --for=condition=Ready pod -l k8s-app=calico-node -n kube-system --timeout=300s

# Join worker nodes using kubeadm join command with token and discovery hash

# Common Issues & Fixes

# Control Plane Taint: Prevents pods from scheduling on master
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# Calico BGP Failures: Ensure port 179 is open in security groups
# Kubelet CGroup Mismatch: containerd must have SystemdCgroup = true
# DNS Resolution Errors: Ensure CoreDNS is running and port 53 allowed in worker nodes SG
# Service Account Token Issues: Verify API server connectivity and service account mounts

# Verification & Testing

# Check nodes and pods
kubectl get nodes -o wide
kubectl get pods -n kube-system

# Test pod-to-pod communication
kubectl run pod1 --image=busybox --command -- sleep 3600
kubectl run pod2 --image=busybox --command -- sleep 3600
kubectl exec pod1 -- ping <pod2-ip>
kubectl exec pod2 -- ping <pod1-ip>

# Test service connectivity
kubectl create deployment nginx-test --image=nginx --replicas=3
kubectl expose deployment nginx-test --port=80 --type=ClusterIP
kubectl run curl-test --image=curlimages/curl --rm -it --restart=Never -- curl nginx-test

# Learnings
# Kubernetes networking is complex and requires correct BGP and pod CIDR configuration
# Security groups are critical for cluster stability
# Infrastructure as Code ensures reproducibility
# Manual cluster deployment teaches troubleshooting and deep understanding beyond managed services like EKS

# Conclusion
# Demonstrates the ability to build a production-grade Kubernetes environment manually, invaluable for learning and experimentation
