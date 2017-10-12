#rds security group
resource "aws_security_group" "db" {
  name = "${var.db_label}-db-${var.environment}"
  description = "Allow SSH traffic from the internet"
  vpc_id = "${var.vpc_id}"
  tags {
    Env = "${var.environment}"
    Class = "securitygroup"
  }
}

#rds security group rules
resource "aws_security_group_rule" "db-egress"{
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.db.id}"

}

resource "aws_security_group_rule" "db-ssh"{
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["${var.source_cidr_block}"]
  security_group_id        = "${aws_security_group.db.id}"
}

resource "aws_security_group_rule" "db-mysql"{
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  cidr_blocks              = ["${var.source_cidr_block}"]
  security_group_id        = "${aws_security_group.db.id}"
}