/*
VPC-wide security groups:
  - base
    - egress traffic via the NAT gateway
    - traffic to/from local VPC's consul cluster
    - SSH from the bastion host, VPN subnet, and management VPC
    - ICMP from the VPN subnet and management VPC
  - public-bastion:
    - SSH from everywhere
    - VPN from everywhere
/*

/*
TODO:

Common services security groups (in a single separate tf module):
  - private-rabbitmq-{{env}}
    - amqp and amqps from the ELB and all VPC subnets
    - amqp management traffic from the ELB and management VPC
    - rabbitmq clustering from private-rabbitmq-{{env}}
  - private-memcache-{{env}}
    - tcp/11211 for memcache traffic from all VPC subnets
  - private-mysql-{{env}}
    - tcp/3306 for mysql traffic from all VPC subnets, the VPN subnet, and the management VPC
  - public-web
    - HTTP and HTTPS from outside our VPC
  - public-rabbitmq
    - amqps from everywhere
    - rabbitmq management traffic from the VPN and our offic

Per-product security groups (in a separate module for each):
  - private-web-{{product}}-{{env}}
    - HTTP from private-varnish-{{product}}-{{env}} and the ELB (for varnish bypass)
    - NFS and glusterfs to/from other members of private-web-{{product}}-{{env}}
  - private-varnish-{{product}}-{{env}}
    - tcp/6081 for HTTP from the ELB and private-web-{{product}}-{{env}}
    - tcp/6082 for varnish control traffic from private-web-{{product}}-{{env}}
  - private-solr-{{product}}-{{env}}
    - tcp/8080 for HTTP from private-web-{{product}}-{{env}}
  - public-web
    - HTTP and HTTPS from outside our VPC
*/

resource "aws_security_group" "base" {
  name        = "base-${var.environment}"
  description = "Base sg for ${var.environment}"
  vpc_id      = "${var.vpc_id}"
  tags {
    Name    = "base-${var.environment}"
    Class   = "securitygroup"
    Product = "${var.product}"
    Env     = "${var.environment}"
  }
}

resource "aws_security_group" "public-bastion" {
  name        = "public-bastion-${var.environment}"
  description = "Public access to Bastion / VPN hosts in ${var.environment}"
  vpc_id      = "${var.vpc_id}"
  tags {
    Name    = "public-bastion-${var.environment}"
    Class   = "securitygroup"
    Product = "${var.product}"
    Env     = "${var.environment}"
  }
}

# base - sg rules
resource "aws_security_group_rule" "base-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1" # all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "base-ssh-mgmt" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  count             = "${var.mgmt_vpc_cidr == "" ? 0 : 1}"
  cidr_blocks       = ["${var.mgmt_vpc_cidr}"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "base-ssh-secure" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  count             = "${var.secure_cidr == "" ? 0 : 1}"
  cidr_blocks       = ["${var.secure_cidr}"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "base-icmp-secure" {
  type              = "ingress"
  from_port         = 0
  to_port           = 255
  protocol          = "1" # ICMP
  count             = "${var.secure_cidr == "" ? 0 : 1}"
  cidr_blocks       = ["${var.secure_cidr}"]
  security_group_id = "${aws_security_group.base.id}"
}

resource "aws_security_group_rule" "base-ssh-bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.public-bastion.id}"
  security_group_id        = "${aws_security_group.base.id}"
}

# public-bastion - sg rules
resource "aws_security_group_rule" "public-bastion-ike" {
  type              = "ingress"
  from_port         = 500 # StrongSWAN - IKEv2
  to_port           = 500
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.public-bastion.id}"
}

resource "aws_security_group_rule" "public-bastion-mobike" {
  type              = "ingress"
  from_port         = 500 # StrongSWAN - IKEv2 MOBIKE / NAT Traversal
  to_port           = 500
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.public-bastion.id}"
}

resource "aws_security_group_rule" "ssh-bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["${var.secure_cidr}"]
  security_group_id        = "${aws_security_group.public-bastion.id}"
}

resource "aws_security_group_rule" "bastion-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1" # all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.public-bastion.id}"
}