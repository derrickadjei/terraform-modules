output "aws_db_instance" {
  value = ["${aws_security_group.db.*.id}"]
}