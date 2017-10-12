

resource "aws_instance" "root_ec2_instance" {
#  ami                    = "${data.aws_ami.debian_stretch.id}"
  ami                    = "${var.ami}"
  count                  = "${var.count}"
  instance_type          = "${var.instance_type}"
  availability_zone      = "${element(var.availability_zones, count.index)}"
  subnet_id              = "${element(var.host_subnets, count.index)}"
  vpc_security_group_ids = ["${var.host_sg_ids}"]
  key_name               = "${var.ssh_key_name}"
  iam_instance_profile   = "${var.instance_profile}"
  root_block_device {
    volume_size = "${var.root_disk["size"]}"
    volume_type = "${var.root_disk["type"]}"
    iops        = "${var.root_disk["iops"]}"
  }
  tags {
    Name    = "${var.product}-${var.class}-${var.environment}"
    Product = "${var.product}"
    Class   = "${var.class}"
    Type    = "ec2_instance"
    Env     = "${var.environment}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Create and associate Elastic IPs
resource "aws_eip" "eip" {
  count = "${var.eip ? var.count : 0}" # create var.count EIPs if var.eip is true
  vpc   = true
}

resource "aws_eip_association" "eip" {
  count         = "${var.eip ? var.count : 0}"
  instance_id   = "${element(aws_instance.ec2_instance.*.id, count.index)}"
  allocation_id = "${element(aws_eip.eip.*.id, count.index)}"
}