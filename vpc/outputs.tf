output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
output "vpc_peer_id" {
  value = "${aws_vpc_peering_connection.mgmt.id}"
}
output "nat_eip" {
  value = "${aws_eip.nat.public_ip}"
}
output "private_subnet_ids" {
  value = ["${aws_subnet.private-subnets.*.id}"]
}
output "public_subnet_ids" {
  value = ["${aws_subnet.public-subnets.*.id}"]
}
