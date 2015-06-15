# input variables
variable api_url { }
variable api_key { }
variable secret_key { }
variable network_id {default = "10.0.0.0/16"}
variable template { default = "centos-7"}
variable control_count { default = "3"}
variable worker_count { default = "1"}
variable control_type { default = "small" }
variable worker_type { default = "small" }
variable zone { default = "dc1" }
variable short_name { default = "mi" }
variable control_name { }
variable worker_name { }
variable keypair_name { }

provider "cloudstack" {
  api_url   = "${ var.api_url }"
  api_key    = "${ var.api_key }"
  secret_key = "${ var.secret_key }"
}

resource "cloudstack_instance" "mi-control-nodes" {
  zone = "${ var.zone }"
  service_offering = "${ var.control_type }"
  template = "${ var.template }"
  control_name = "${ var.short_name }-control-${ format("%02d", count.index+1) }"
  network = "${ var.network_id }"
  count = "${ var.control_count }"
  keypair = ${ var.keypair_name }
}

resource "cloudstack_instance" "mi-worker-nodes" {
  zone = "${ var.zone }"
  service_offering = "${ var.worker_type }"
  template = "${ var.template }"
  worker_name = "${ var.short_name }-worker-${ format("%02d", count.index+1) }"
  network = "${ var.network_id }"
  count = "${ var.worker_count }"
  keypair = ${ var.keypair_name }
}