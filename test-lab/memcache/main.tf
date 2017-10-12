module "memcache" {
  source = "../../memcache"

  zoneid             = "${var.zoneid}"
  vpc_id             = "${var.vpc_id}"
  product            = "${var.product}"
  vpc_cidr           = "${var.vpc_cidr}"
  node_type          = "${var.node_type}"
  cluster_id         = "${var.cluster_id}"
  subnet_ids         = "${var.subnet_ids}"
  environment        = "${var.environment}"
  engine_version     = "${var.engine_version}"
}
