resource "aws_instance" "control_plane" {
  ami = "ami-0a91cd140a1fc148a"
  instance_type = "t3.medium"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.control_plane.id]
  user_data = file("${path.module}/userdata/master_userdata.sh")
  tags = { Name = "${var.cluster_name}-control-plane" }
}
resource "aws_instance" "worker_nodes" {
  count = 2
  ami = "ami-0a91cd140a1fc148a"
  instance_type = "t3.small"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.worker_nodes.id]
  user_data = file("${path.module}/userdata/worker_userdata.sh")
  tags = { Name = "${var.cluster_name}-worker-${count.index+1}" }
}