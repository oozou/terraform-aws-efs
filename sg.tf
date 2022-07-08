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

resource "aws_security_group_rule" "additional_cluster_ingress" {
  count                    = local.enabled ? length(var.additional_cluster_security_group_ingress_rules) : null
  type                     = "ingress"
  from_port                = lookup(var.additional_cluster_security_group_ingress_rules[count.index], "from_port", 0)
  to_port                  = lookup(var.additional_cluster_security_group_ingress_rules[count.index], "to_port", 65535)
  protocol                 = lookup(var.additional_cluster_security_group_ingress_rules[count.index], "protocol", "tcp")
  cidr_blocks              = lookup(var.additional_cluster_security_group_ingress_rules[count.index], "cidr_blocks", null)
  source_security_group_id = lookup(var.additional_cluster_security_group_ingress_rules[count.index], "source_security_group_id", null)
  description              = lookup(var.additional_cluster_security_group_ingress_rules[count.index], "description", "additional rule for efs")
  security_group_id        = aws_security_group.efs.id
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
