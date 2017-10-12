#elastic load balancers


resource "aws_elb" "elb" {
  name            = "${var.product}-${var.environment}"
  subnets         = ["${var.subnets}"]
  security_groups = ["${var.elb_Security_group_ids}"]
  internal        = "${var.internal}"
  tags {
    Name    = "${var.product}-elb-${var.environment}"
    Class   = "elb"
    Product = "${var.product}"
    Env     = "${var.environment}"
  }

  listener {
    instance_port     = "${var.instance_port}"
    instance_protocol = "${var.instance_protocol}"
    lb_port           = 80
    lb_protocol       = "http"
  }
  listener {
    instance_port      = "${var.instance_port}"
    instance_protocol  = "${var.instance_protocol}"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.ssl_cert_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "${var.target}"
    interval            = 30
  }

#  instances                   = ["${aws_instance.rnd17-webcache-a.*.id}","${aws_instance.rnd17-webcache-b.*.id}", "${aws_instance.rnd17-webcache-c.*.id}"]
  instances                   = ["${var.instances}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

#RDS route 53
#resource "aws_route53_record" "elb-route" {
#   zone_id = "${var.zoneid}"
#   name    = "${var.elb_label}-${var.environment}.sys.comicrelief.com"
#   type    = "CNAME"
#   ttl     = "300"
#   records = ["${aws_elb.elb.dns_name}"]
#}