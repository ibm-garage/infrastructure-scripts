
resource "ibm_resource_instance" "sysdig" {
  name     = "sysdig-${var.suffix}"
  service  = "sysdig-monitor"
  plan     = "graduated-tier"
  location = "${var.region}"
  resource_group_id = data.ibm_resource_group.this.id
}

resource "ibm_resource_key" "monResourceKey" {
  name                 = "key-sysdig-${var.suffix}"
  resource_instance_id = ibm_resource_instance.sysdig.id
  role                 = "Manager"
}

resource "ibm_ob_monitoring" "config" {
  depends_on  = [ibm_resource_key.monResourceKey]
  cluster     = "${var.cluster_instance_id}"
  instance_id = ibm_resource_instance.sysdig.guid
}
