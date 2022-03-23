
terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~>1.38.0"
    }
  }
  required_version = "~> 1.0"
}

locals {
    # Link to Cloudflare IPS here: https://cloud.ibm.com/docs/cis?topic=cis-cis-allowlisted-ip-addresses
    # These should be checked for updates periodically - they say once a week, they seem to change much less
    # frequently than that.
    cloudflare_ips = ["173.245.48.0/20", 
                      "103.21.244.0/22",
                      "103.22.200.0/22",
                      "103.31.4.0/22",
                      "141.101.64.0/18",
                      "108.162.192.0/18",
                      "190.93.240.0/20",
                      "188.114.96.0/20",
                      "197.234.240.0/22",
                      "198.41.128.0/17",
                      "162.158.0.0/15",
                      "104.16.0.0/13",
                      "104.24.0.0/14",
                      "172.64.0.0/13",
                      "131.0.72.0/22"]
}


# Allow inbound traffic for Cloudflare IPs
resource "ibm_is_security_group_rule" "security_group_rule_k8s" {
  for_each  = toset(local.cloudflare_ips)
  group     = var.sg_id
  direction = "inbound"
  remote    = each.value

  tcp {
    port_min = 1
    port_max = 65535
  }
}