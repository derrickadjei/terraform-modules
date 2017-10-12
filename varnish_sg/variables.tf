variable "source_cidr_block" {
  description = "The source CIDR block to allow traffic from"
  default     = ["0.0.0.0/0"]
  type        = "list"
}
variable "vpc_id"      {}
variable "sg_label"    {}
variable "environment" {}
variable "product"     {}
variable "vpc_cidr"    { type = "list" }