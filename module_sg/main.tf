
resource "aws_security_group" "sg_default" {
  name                   = var.sg_name
  description            = var.sg_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.ingress_cidr_blocks
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}

/*
# Ingress - List of rules (simple)
###################################
# Security group rules with "cidr_blocks" and it uses list of rules names
resource "aws_security_group_rule" "ingress_rules" {

  security_group_id = aws_security_group.sg_default.id
  type              = "ingress"

  cidr_blocks      = var.ingress_cidr_blocks
  ipv6_cidr_blocks = var.ingress_ipv6_cidr_blocks
  prefix_list_ids  = var.ingress_prefix_list_ids
  description      = var.sg_description

  from_port = var.fromport
  to_port = var.toport
  protocol = var.protocol
  #from_port = var.rules[var.ingress_rules[count.index]][0]
  #to_port   = var.rules[var.ingress_rules[count.index]][1]
  #protocol  = var.rules[var.ingress_rules[count.index]][2]
}

*/