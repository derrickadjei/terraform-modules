

#route 53
resource "aws_route53_record" "route_53" {
   zone_id = "${var.zoneid}"
   name    = "${var.route_label}-${var.environment}.sys.comicrelief.com"
   type    = "${var.type}"
   ttl     = "300"
   records = ["${var.records}"]
}