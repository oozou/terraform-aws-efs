# security group for the cluster
resource "aws_security_group" "efs" {
  name        = "${local.service_name}-efs-sg"
  description = "security group for the EFS"
  vpc_id      = var.vpc_id

  tags = merge({
    Name = "${local.service_name}-efs-sg"
  }, local.tags)
}

# security group rule for incoming efs connection
resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.efs.id
  description       = "Ingress rule for the EFS security group"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"

  source_security_group_id = aws_security_group.client.id
}

# security group for clients
resource "aws_security_group" "client" {
  name        = "${local.service_name}-efs-client-sg"
  description = "security group for the efs client"
  vpc_id      = var.vpc_id

  tags = merge({
    Name = "${local.service_name}-efs-client-sg"
  }, local.tags)
}

# security group rule for outgoing efs connection
resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.client.id
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"

  source_security_group_id = aws_security_group.efs.id
}
