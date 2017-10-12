# 0 = false
# 1 = true
#private webserver security group
#Security group and rules for security groups tailored to cr

resource "aws_security_group" "base" {
  name        = "${var.product}-${var.environment}"
  description = "Security group for ${var.product}-${var.environment}"
  vpc_id      = "${var.vpc_id}"
  tags {
    Name    = "${var.product}-${var.environment}"
    Class   = "securitygroup"
    Product = "${var.product}"
    Env     = "${var.environment}"
  }
}

#base - sg rules

##############
# egress rule
##############

resource "aws_security_group_rule" "egress" {
  count             = "${var.egress == "" ? 0 : 1}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.base.id}"

}


################
#  Global rules
################
resource "aws_security_group_rule" "ssh" {
  count             = "${var.ssh == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.source_cidr_block}"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "http"{
  count             = "${var.http == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["${var.source_cidr_block}"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "https" {
    count             = "${var.https == "" ? 0 : 1}"
    type              = "ingress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.base.id}"
  }



################
#  web rules
################
  resource "aws_security_group_rule" "port_24007" {
  count             = "${var.port_24007 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 24007
  to_port           = 24007
  protocol          = "tcp"
  security_group_id = "${aws_security_group.base.id}"
  self              = true
}

resource "aws_security_group_rule" "port_49152" {
  count             = "${var.port_49152 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 49152
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = "${aws_security_group.base.id}"
  self              = true
}

resource "aws_security_group_rule" "port_111" {
  count             = "${var.port_111 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 111
  to_port           = 111
  protocol          = "tcp"
  security_group_id = "${aws_security_group.base.id}"
  self              = true
}

resource "aws_security_group_rule" "rule_for_port_8301" {
  count             = "${var.port_8300 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 8300
  to_port           = 8301
  protocol          = "tcp"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "udp_port_8300" {
  count             = "${var.udp_port_8300 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 8300
  to_port           = 8301
  protocol          = "udp"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "rule_for_port_2049" {
  count             = "${var.port_2049 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = "${aws_security_group.base.id}"
  self              = true
}

resource "aws_security_group_rule" "rule_for_port_24009" {
  count             = "${var.port_24009 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 24009
  to_port           = 24009
  protocol          = "tcp"
  security_group_id = "${aws_security_group.base.id}"
  self              = true
}

resource "aws_security_group_rule" "rule_for_port_24010" {
  count             = "${var.port_24010 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 24010
  to_port           = 24010
  protocol          = "tcp"
  security_group_id = "${aws_security_group.base.id}"
  self              = true
}

resource "aws_security_group_rule" "rule_for_port_38465" {
  count             = "${var.port_38465 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 38465
  to_port           = 38465
  protocol          = "tcp"
  security_group_id = "${aws_security_group.base.id}"
  self              = true
}

resource "aws_security_group_rule" "rule_for_port_38466" {
  count             = "${var.port_38466 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 38466
  to_port           = 38466
  protocol          = "tcp"
  security_group_id = "${aws_security_group.base.id}"
  self              = true
}

resource "aws_security_group_rule" "rule_for_udp_port_111" {
  count             = "${var.udp_port_111 == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 111
  to_port           = 111
  protocol          = "udp"
  security_group_id = "${aws_security_group.base.id}"
  self              = true
}

##############
# Varnish rule
##############
resource "aws_security_group_rule" "varnishd" {
  count             = "${var.varnishd == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 6081
  to_port           = 6081
  protocol          = "tcp"
  cidr_blocks       = ["${var.source_cidr_block}"]
  security_group_id = "${aws_security_group.base.id}"
}


##############
# RDS rule
##############
resource "aws_security_group_rule" "mysql" {
  count             = "${var.mysql == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["${var.source_cidr_block}"]
  security_group_id = "${aws_security_group.base.id}"
}


##############
# Bastion rule
##############

resource "aws_security_group_rule" "public-bastion-ike" {
  count             = "${var.bastion_ike == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 500 # StrongSWAN - IKEv2
  to_port           = 500
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "public-bastion-mobike" {
  count             = "${var.bastion_mobike == "" ? 0 : 1}"
  type              = "ingress"
  from_port         = 500 # StrongSWAN - IKEv2 MOBIKE / NAT Traversal
  to_port           = 500
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "bastion-egress" {
  count             = "${var.bastion_egress == "" ? 0 : 1}"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1" # all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.base.id}"
}
