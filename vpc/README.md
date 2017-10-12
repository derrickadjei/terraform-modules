# AWS VPC Configuration

## Requirements

- A list of availability zones within a single AWS region
- A block of IP addresses for the VPC as a whole
- A list of subnets within that block to use for our public-facing networks (at least one per az)
- A list of subnets within that block to use for our private networks (at least one per az)

## Optional

- A product tag (defaults to 'vpc' if not supplied)
- Details of a Management VPC to which a peering connection will be created

*If the Management VPC resides in an external account, the peering request must be accepted manually*