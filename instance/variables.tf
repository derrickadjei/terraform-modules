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
variable "subnets"       { type = "list" }
variable "sg_ids"        { type = "list" }

