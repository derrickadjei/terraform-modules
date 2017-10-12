#private webserver security group

resource "aws_security_group" "varnish" {
  name        = "${var.sg_label}-${var.environment}"
  description = "Manage connections to varnish for ${var.environment}"
  vpc_id      = "${var.vpc_id}"
  tags {
    Name    = "varnish-${var.environment}"
    Class   = "securitygroup"
    Product = "${var.product}"
    Env     = "${var.environment}"
  }
}

#web-base - sg rules
resource "aws_security_group_rule" "web-base-egress"{
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.varnish.id}"

}

resource "aws_security_group_rule" "web-ssh"{
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["${var.source_cidr_block}"]
  security_group_id        = "${aws_security_group.varnish.id}"
}

resource "aws_security_group_rule" "varnishd"{
  type                     = "ingress"
  from_port                = 6081
  to_port                  = 6081
  protocol                 = "tcp"
  cidr_blocks              = ["${var.source_cidr_block}"]
  security_group_id        = "${aws_security_group.varnish.id}"
}

resource "aws_security_group_rule" "rule_to_port_6082"{
  type                     = "ingress"
  from_port                = 6082
  to_port                  = 6082
  protocol                 = "tcp"
  cidr_blocks              = ["${var.source_cidr_block}"]
  security_group_id        = "${aws_security_group.varnish.id}"
}

resource "aws_security_group_rule" "rule_to_port_8300"{
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8301
  protocol                 = "tcp"
  cidr_blocks              = ["${var.vpc_cidr}"]
  security_group_id        = "${aws_security_group.varnish.id}"
}

resource "aws_security_group_rule" "rule_to_udp_port_8300"{
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8301
  protocol                 = "udp"
  cidr_blocks              = ["${var.vpc_cidr}"]
  security_group_id        = "${aws_security_group.varnish.id}"
}