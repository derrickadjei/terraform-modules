output "base" {
  value = ["${aws_security_group.base.*.id}"]
}
output "public-bastion" {
  value = ["${aws_security_group.public-bastion.*.id}"]
}