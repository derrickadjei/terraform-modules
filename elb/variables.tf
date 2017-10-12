
variable environment       {}
variable zoneid            {}
variable product           {}
variable instance_port     { default = "6081" }
variable instance_protocol { default = "HTTP" }
variable ssl_cert_id       {}
variable target            {}
variable internal          {}
variable instances         { type = "list" }
variable subnets           { type = "list" }
variable elb_sgids         { type = "list" }
