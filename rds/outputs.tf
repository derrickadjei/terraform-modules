output "rds" {
  value = ["${aws_db_instance.rds_instance.address}"]
}