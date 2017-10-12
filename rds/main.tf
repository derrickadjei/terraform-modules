# Create an RDS instance

resource "aws_db_instance" "rds_instance" {
  identifier           = "${var.identifier}-${var.environment}"
  allocated_storage    = "${var.allocated_storage}"
  storage_type         = "${var.storage_type}"
  multi_az             = "${var.multiple_azones}"
  engine               = "${var.engine}"
  engine_version       = "${var.engine_version}"
  instance_class       = "${var.instance_class}"
  name                 = "${var.name}"
  username             = "${var.username}"
  password             = "${var.password}"
  db_subnet_group_name = "${aws_db_subnet_group.db.name}"
  parameter_group_name = "${aws_db_parameter_group.db.name}"
  skip_final_snapshot  = "${var.skip_final_snapshot}"
  vpc_security_group_ids = ["${var.rds_sg_ids}"]
}

# RDS parameter group
resource "aws_db_parameter_group" "db" {
    name        = "${var.parameter_group_label}-${var.environment}"
    family      = "${var.family}"
    description = "RDS default parameter group"

    parameter {
      name      = "character_set_server"
      value     = "utf8"
    }

    parameter {
      name      = "character_set_client"
      value     = "utf8"
    }
}

#RDS subnet group
resource "aws_db_subnet_group" "db" {
    name        = "${var.subnet_group_label}-${var.environment}"
    description = "Subnet group for rnd MySQL db"
    subnet_ids  = ["${var.private_subnet_ids}"]
}

#RDS route 53
#resource "aws_route53_record" "db-route" {
#   zone_id = "${var.zoneid}"
#   name    = "${var.rds_route_label}-${var.environment}.sys.comicrelief.com"
#   type    = "CNAME"
#   ttl     = "300"
#   records = ["${aws_db_instance.rds_instance.address}"]
#}

