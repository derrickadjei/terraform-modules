# Security Group Module

All infrastructure security groups can be created from this module.

This module contains One scurity group and multiple security group rules that can be reused.

Each rule has been automatically set to false using the count parmeter 'count = "${var.mysql == "" ? 0 : 1}"' and would need to be set to true when calling the modules.


> Current security group rules:
>
> * egress
> * ssh
> * http
> * https
> * port_24007
> * port_49152
> * port_111
> * port_8300
> * udp_port_8300
> * port_2049
> * port_24009
> * port_24010
> * port_38465
> * port_38466
> * udp_port_111
> * varnishd
> * mysql
> * bastion_ike
> * bastion_mobike
> * bastion_egress