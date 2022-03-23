# Cloudflare Security Group Rules

This is a utility module for adding security group rules that allow inbound traffic from known inbound IPs to a specified Security Group.

A link to Cloudflare IPs can be found here: https://cloud.ibm.com/docs/cis?topic=cis-cis-allowlisted-ip-addresses

It is possible that the IPs will change and this utility will get out of sync, so it is best to check.

And example of where you might use this, is to create a security group that you attach to an ALB or Virtual Firewall Appliance interface to only permit traffic from Cloudflare (Cloud Internet Services)


## Pre-requisites:
1.  A security group to which these rules will be added
   
| Name | Description | Type | Default/Example | Required |
| ---- | ----------- | ---- | ------- | -------- |
| sg_id | The GUID of the Security Group to which the rules will be added | string | N/A | yes |