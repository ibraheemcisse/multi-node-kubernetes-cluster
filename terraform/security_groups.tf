resource "aws_security_group" "control_plane" { name = "${var.cluster_name}-control-plane" description = "Control plane security group" vpc_id = var.vpc_id }
resource "aws_security_group" "worker_nodes" { name = "${var.cluster_name}-workers" description = "Worker nodes security group" vpc_id = var.vpc_id }
resource "aws_security_group" "alb" { name = "${var.cluster_name}-alb" description = "ALB security group" vpc_id = var.vpc_id }
resource "aws_security_group" "database" { name = "${var.cluster_name}-database" description = "Database security group" vpc_id = var.vpc_id }