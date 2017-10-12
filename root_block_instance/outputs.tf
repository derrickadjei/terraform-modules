

output "private_ip" { value = "${aws_instance.root_ec2_instance.private_ip}" }
output "eip"        { value = ["${aws_eip.eip.public_ip}"] }
output "instance"   { value = "${aws_instance.root_ec2_instance.*.id}" }