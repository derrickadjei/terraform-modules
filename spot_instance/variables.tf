variable "product" {}
variable "class" {}
variable "instance_type" {}
variable "ssh_key_name" {}
variable "spot_price" {}
variable "count" {
  default = 1
}
variable "availability_zones" {
  type = "list"
}
