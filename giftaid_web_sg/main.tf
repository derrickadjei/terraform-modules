#giftaid webserver security group

#web security group specifically tailored to giftaid (should only be used when developing giftaid)
#Create a web server instance to go along with security group
# Give group rules better names :)

resource "aws_security_group" "web-base" {
  name        = "${var.sg_label}-${var.environment}"
  description = "web-base security group for ${var.environment}"
  vpc_id      = "${var.vpc_id}"
  tags {
    Name    = "${var.sg_label}-${var.environment}"
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
  security_group_id = "${aws_security_group.web-base.id}"

}

resource "aws_security_group_rule" "web-ssh"{
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["${var.source_cidr_block}"]
  security_group_id        = "${aws_security_group.web-base.id}"
}

resource "aws_security_group_rule" "web-http"{
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["${var.source_cidr_block}"]
  security_group_id        = "${aws_security_group.web-base.id}"
}

resource "aws_security_group_rule" "rule_for_port_24007"{
  type                     = "ingress"
  from_port                = 24007
  to_port                  = 24007
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web-base.id}"
  self                     = true
}

resource "aws_security_group_rule" "rule_for_port_49152"{
  type                     = "ingress"
  from_port                = 49152
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web-base.id}"
  self                     = true
}

resource "aws_security_group_rule" "rule_for_port_111"{
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web-base.id}"
  self                     = true
}

resource "aws_security_group_rule" "rule_for_port_8301"{
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8301
  protocol                 = "tcp"
  cidr_blocks              = ["${var.vpc_cidr}"]
  security_group_id        = "${aws_security_group.web-base.id}"
}

resource "aws_security_group_rule" "rule_for_port_8300"{
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8301
  protocol                 = "udp"
  cidr_blocks              = ["${var.vpc_cidr}"]
  security_group_id        = "${aws_security_group.web-base.id}"
}

resource "aws_security_group_rule" "rule_for_port_2049"{
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web-base.id}"
  self                     = true
}

resource "aws_security_group_rule" "rule_for_port_24009"{
  type                     = "ingress"
  from_port                = 24009
  to_port                  = 24009
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web-base.id}"
  self                     = true
}

resource "aws_security_group_rule" "rule_for_port_24010"{
  type                     = "ingress"
  from_port                = 24010
  to_port                  = 24010
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web-base.id}"
  self                     = true
}

resource "aws_security_group_rule" "rule_for_port_38465"{
  type                     = "ingress"
  from_port                = 38465
  to_port                  = 38465
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web-base.id}"
  self                     = true
}

resource "aws_security_group_rule" "rule_for_port_38466"{
  type                     = "ingress"
  from_port                = 38466
  to_port                  = 38466
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web-base.id}"
  self                     = true
}

resource "aws_security_group_rule" "rule_for_udp_port_111"{
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.web-base.id}"
  self                     = true
}