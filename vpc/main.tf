# Create a VPC, and associated gateways, routes, and peering configuration

data "aws_caller_identity" "current" {}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"
  tags {
    Env     = "${var.environment}"
    Name    = "vpc-${var.environment}"
    Class   = "vpc"
    Product = "${var.product}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# If a mgmt vpc is defined, create a peering connection from it to us
# TODO: Work out how to accept the connection automatically if the mgmt vpc is in a separate account!
resource "aws_vpc_peering_connection" "mgmt" {
  peer_owner_id = "${var.mgmt_account}"
  peer_vpc_id   = "${aws_vpc.vpc.id}"
  vpc_id        = "${var.mgmt_vpc["id"]}"
  count         = "${length(var.mgmt_vpc)}"
  auto_accept   = "${var.mgmt_account == data.aws_caller_identity.current.account_id ? true : false}"
  tags {
    Env     = "${var.environment}"
    Name    = "peer-mgmt-${var.environment}"
    Class   = "peer"
    Product = "${var.product}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Ingress and Egress (NAT) gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Env     = "${var.environment}"
    Name    = "igw-${var.environment}"
    Class   = "igw"
    Product = "${var.product}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public-subnets.0.id}"
  lifecycle {
    create_before_destroy = true
  }
}

/*
Network configuration:
- two subnets per availability zone
  - public, for resources accessible from external networks (eg. ELBs or
    instances with and EIP attachment)
  - private, for resources accessible only from our VPC
- a pair of public and private routing tables, one associated with each set of subnets
- some initial routes, which get added to the routing tables
  - public-base, to/from the igw
  - private-base, to the nat gw
  - public-mgmt & private-mgmt, via the mgmt peering connection
  - we can also add other routes later, eg. when we create our VPN/bastion host
*/

resource "aws_subnet" "public-subnets" {
  vpc_id            = "${aws_vpc.vpc.id}"
  count             = "${length(var.availability_zones)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${element(var.public_subnets, count.index)}"
  tags {
    Env     = "${var.environment}"
    Name    = "public-subnet-${element(var.availability_zones, count.index)}"
    Type    = "public_subnet"
    Product = "${var.product}"
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id            = "${aws_vpc.vpc.id}"
  count             = "${length(var.availability_zones)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  tags {
    Env     = "${var.environment}"
    Name    = "private-subnet-${element(var.availability_zones, count.index)}"
    Type    = "private_subnet"
    Product = "${var.product}"
  }
}

# Routing setup for one public-facing and one private-facing subnet per availability zone
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Env     = "${var.environment}"
    Name    = "public-routes"
    Type    = "public_route_table"
    Product = "${var.product}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "private" {
#  count  = "${length(var.public_subnets)}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Env     = "${var.environment}"
    Name    = "private-routes"
    Type    = "private_route_table"
    Product = "${var.product}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public-subnets.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id,count.index)}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private-subnets.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id,count.index)}"
}

resource "aws_route" "public_base" {
  count                  = "${length(var.public_subnets)> 0 ? 1 : 0}"
  route_table_id         = "${element(aws_route_table.public.*.id,count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  depends_on             = ["aws_route_table.public"] # Route tables take a while to create, so force Terraform to wait
}

resource "aws_route" "private_base" {
  count                  = "${length(var.private_subnets)> 0 ? 1 : 0}"
  route_table_id         = "${element(aws_route_table.private.*.id,count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat-gateway.id}"
  depends_on             = ["aws_route_table.private"] # Route tables take a while to create, so force Terraform to wait
}

resource "aws_route" "public_mgmt" {
  route_table_id            = "${element(aws_route_table.public.*.id,count.index)}"
  destination_cidr_block    = "${var.mgmt_vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.mgmt.0.id}"
  count                     = "${length(var.mgmt_vpc)}" # only create if the mgmt vpc is defined
  depends_on                = ["aws_route_table.public"]
}

resource "aws_route" "private_mgmt" {
  route_table_id            = "${element(aws_route_table.private.*.id,count.index)}"
  destination_cidr_block    = "${var.mgmt_vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.mgmt.0.id}"
  count                     = "${length(var.mgmt_vpc)}" # only create if the mgmt vpc is defined
  depends_on                = ["aws_route_table.public"]
}