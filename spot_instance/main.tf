
# create a spot instance

data "aws_ami" "debian_stretch" {
  most_recent = true
  owners      = ["379101102735"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["debian-stretch-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "spot" {
  name        = "spot-${var.product}-${var.class}"
  description = "sg for spot instances"
  tags {
    Name    = "spot-${var.product}-${var.class}"
    Class   = "securitygroup"
    Product = "${var.product}"
  }
}

resource "aws_security_group_rule" "spot-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.spot.id}"
}

resource "aws_security_group_rule" "spot-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.spot.id}"
}


resource "aws_spot_instance_request" "spot_instance" {
  ami                  = "${data.aws_ami.debian_stretch.id}"
  count                = "${var.count}"
  instance_type        = "${var.instance_type}"
  availability_zone    = "${element(var.availability_zones, count.index)}"
  key_name             = "${var.ssh_key_name}"
  spot_price           = "${var.spot_price}"
  spot_type            = "one-time"
  wait_for_fulfillment = true # Required in order to provide the user_data
  user_data            = "${data.template_file.user_data_shell.rendered}" # Copy tags from the Spot request to the instance (see below)
  security_groups      = ["${aws_security_group.spot.name}"] # Default VPC SGs get called by name, not id
  iam_instance_profile = "${aws_iam_instance_profile.spot.name}"
  associate_public_ip_address = true
  tags {
    Name    = "${var.product}-${var.class}-${count.index}"
    Product = "${var.product}"
    Class   = "${var.class}"
    Type    = "spot_instance"
  }
}

/*
We set the tags on aws_spot_instance_request but these tags are not forwarded
by AWS to the actual instance when the request in fulfilled. Instead, we run
this user data script to copy the tags to the instance.
For details, see:
https://github.com/terraform-providers/terraform-provider-aws/issues/174
http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-requests.html
*/
data "template_file" "user_data_shell" {
  template = <<-EOF
    #!/bin/bash
    sleep 30
    apt-get -q -y update
    apt-get -q -y install python-minimal curl jq
    sleep 30
    REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)
    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    SPOT_REQ_ID=$(aws --region $REGION ec2 describe-instances --instance-ids "$INSTANCE_ID"  --query 'Reservations[0].Instances[0].SpotInstanceRequestId' --output text)
    if [ "$SPOT_REQ_ID" != "None" ] ; then
      TAGS=$(aws --region $REGION ec2 describe-spot-instance-requests --spot-instance-request-ids "$SPOT_REQ_ID" --query 'SpotInstanceRequests[0].Tags')
      aws --region $REGION ec2 create-tags --resources "$INSTANCE_ID" --tags "$TAGS"
    fi
  EOF
}


# Create an instance policy to allow the instance to update its tags

data "aws_iam_policy_document" "spot" {
  statement {
    effect     = "Allow"
    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions    = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "spot_policy" {
  statement {
    effect    = "Allow"
    actions   = [
                  "tag:*",
                  "ec2:Describe*",
                  "ec2:CreateTags",
                  "ec2:DeleteTags",
                  "ec2:ModifyInstanceAttribute"
                ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "spot" {
  name               = "spot-${var.product}-${var.class}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.spot.json}"
}

resource "aws_iam_role_policy" "spot_policy" {
  name   = "spot-${var.product}-${var.class}"
  role   = "${aws_iam_role.spot.id}"
  policy = "${data.aws_iam_policy_document.spot_policy.json}"
}

resource "aws_iam_instance_profile" "spot" {
  name  = "spot-${var.product}-${var.class}"
  role = "${aws_iam_role.spot.name}"
}
