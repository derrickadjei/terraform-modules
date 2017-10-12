variable "identifier"            {}
variable "environment"           {}
variable "engine_version"        {}
variable "allocated_storage"     {}
variable "name"                  {}
variable "username"              {}
variable "password"              {}
variable "subnet_group_label"    {}
variable "multiple_azones"       {}
variable "parameter_group_label" {}
variable "zoneid"                {}
variable "rds_route_label"       {}
variable "skip_final_snapshot"   {}
variable "storage_type"          { default = "rds_mysql" }
variable "family"                { default = "mysql5.6" }
variable "instance_class"        { default = "db.t1.micro" }
variable "engine"                { default = "mysql" }
variable "private_subnet_ids"    { type = "list" }
variable "rds_sg_ids"            { type = "list" }
#variable "storage_type"         { default = "gp2" }