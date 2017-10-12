# ELB Module;

This module currently creates an Elastic Load Balance for your infrastructure.
The ELB resource is modularised to accomodate different comic relief products.
Parameters are designed to keep consistent naming conventions within AWS, giving cr consistent clean infrastructure.

for example '"${var.elb_label}-elb-${var.environment}"' would allow you to choose a name and select which enviroment this should be developed in.

This module currently creates a route53 reocrd for this ELB. This should soon be removed in favour of the route53 module.

To use this module:

add git URL to your resource source parameter.
run 'terraform get'
