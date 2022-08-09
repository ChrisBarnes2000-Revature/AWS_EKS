# worker group 1
resource "aws_security_group" "worker_group_node" {
  name_prefix = "worker_node_sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.my_home_ip,
      "10.0.0.0/8"
    ]
  }
}

# worker group 2
resource "aws_security_group" "all_sg" {
  name_prefix = "all_nodes_sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
      "172.16.0.0/12"
    ]
  }
}
