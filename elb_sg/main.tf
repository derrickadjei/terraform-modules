#elastic load balancers security group


resource "aws_security_group" "elb-base" {
  name        = "${var.elb_label}-${var.environment}"
  description = "Manage connections to varnish servers"
  vpc_id      = "${var.vpc_id}"
  tags {
    Env   = "${var.environment}"
    Class = "securitygroup"
  }
}

#elb-base - sg rules
resource "aws_security_group_rule" "web-base-egress"{
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.elb-base.id}"
}

resource "aws_security_group_rule" "elb-http"{
  type                = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.elb-base.id}"
  }

resource "aws_security_group_rule" "elb-https"{
  type                = "ingress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.elb-base.id}"
  }
