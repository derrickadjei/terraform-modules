

variable "environment"        { default = "test" }
variable "product"            { default = "vpc" }
variable "vpc_cidr_block"     {}
variable "mgmt_account"       { default = "" }
variable "availability_zones" { type = "list" }
variable "private_subnets"    { type = "list" }
variable "public_subnets"     { type = "list" }
variable "mgmt_vpc"           { type    = "map" default = {} }