
resource "aws_security_group" "sg_default" {
  name                   = var.sg_name
  description            = var.sg_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags = var.tags
  )

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}