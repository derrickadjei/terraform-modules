variable "dynamodb_name"           {}
variable "dynamodb_hash_key"       {}
variable "dynamodb_attribute_name" {}
variable "dynamodb_attribute_type" {}

variable "dynamodb_environment"    { default = "test" }
variable "dynamodb_read_capacity"  { default = "20" }
variable "dynamodb_write_capacity" { default = "20" }
