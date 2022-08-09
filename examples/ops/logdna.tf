resource "ibm_resource_instance" "logdna" {
  name     = "logdna-${var.suffix}"
  service  = "logdna"
  plan     = "7-day"
  location = "${var.region}"
  resource_group_id = data.ibm_resource_group.this.id
}

resource "ibm_resource_key" "logResourceKey" {
  name                 = "key-logdna-${var.suffix}"
  resource_instance_id = ibm_resource_instance.logdna.id
  role                 = "Manager"
}

resource "ibm_ob_logging" "config" {
  depends_on  = [ibm_resource_key.logResourceKey]
  cluster     = "${var.cluster_instance_id}"
  instance_id = ibm_resource_instance.logdna.guid
} 

resource "ibm_container_bind_service" "logdna_binding" {
  cluster_name_id             = "${var.cluster_instance_id}"
  service_instance_name       = ibm_resource_instance.logdna.name
  namespace_id                = "${var.namespace_id}"
  resource_group_id           = data.ibm_resource_group.this.id
  role                        = "Manager"

}