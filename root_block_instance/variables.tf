variable "product"          {}
variable "environment"      {}
variable "class"            {}
variable "instance_type"    {}
variable "instance_profile" {}
variable "ssh_key_name"     {}
variable "ami"              {}
variable "count"              { default = 1 }
variable "eip"                { default = false }
variable "availability_zones" { type = "list" }
variable "host_subnets"       { type = "list" }
variable "host_sg_ids"        { type = "list" }
variable "root_disk" {
  type    = "map"
  default = {
     type = "gp2"
     size = 20
     iops = 0
  }
}
