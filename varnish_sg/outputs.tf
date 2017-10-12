output "varnish" {
  value = ["${aws_security_group.varnish.*.id}"]
}
#output "varnish-elb" {
#  value = ["${aws_security_group.varnish-elb.*.id}"]
#}