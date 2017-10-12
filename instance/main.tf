# Create an EC2 instance

/*
TODO - We're currently simply selecting the latest version of Debian 9 'Stretch'
       available in our region. In future, we should instead our own AMIs,
       encrypted with a project-specific KMS key. These can then be used to
       create instances with boot volume encryption enabled.
*/

# Find the Debian 9 AMI for our region
#  - see https://wiki.debian.org/Cloud/AmazonEC2Image/Stretch for details
#data "aws_ami" "debian_stretch" {
#  most_recent = true
#  owners      = ["379101102735"]
#  filter {
#    name   = "architecture"
#    values = ["x86_64"]
#  }
#  filter {
#    name   = "name"
##    values = ["debian-stretch-*"]
#  }
#  filter {
#    name   = "root-device-type"
#    values = ["ebs"]
#  }
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#}

resource "aws_instance" "ec2_instance" {
#  ami                    = "${data.aws_ami.debian_stretch.id}"
  ami                    = "${var.ami}"
  count                  = "${var.count}"
  instance_type          = "${var.instance_type}"
  availability_zone      = "${element(var.availability_zones, count.index)}"
  subnet_id              = "${element(var.sunets, count.index)}"
  vpc_security_group_ids = ["${var.sg_ids}"]
  key_name               = "${var.ssh_key_u

ss
name}"
  iam_instance_profile   = "${var.instance_profile}"
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
