variable keypair_name { }
variable tenant_name { default = "CCS-MI-US-INTERNAL-1-QA-3" }
variable flavor_name { default = "Micro-Small" }
variable image_name { default = "centos-7_x86_64-2015-01-27-v6" }
variable security_groups { default = "default" }
variable floating_pool { default = "public-floating-601" }
variable external_net_id { default = "ca80ff29-4f29-49a5-aa22-549f31b09268" }
variable subnet_cidr { default = "10.10.10.0/24" }
variable ip_version { default = "4" }
variable short_name { default = "mi" }
######################################################
#       Variables for floating control               #
######################################################
variable control_float_names { default = "mi-control-01,mi-control-03," }
variable resource_float_names { default = "mi-worker-01," }
variable control_names { default = "mi-control-01,mi-control-03," }
variable resource_names { default = "mi-worker-01," }

provider "openstack" {
  auth_url      = "${ var.auth_url }"
  tenant_id     = "${ var.tenant_id }"
  tenant_name   = "${ var.tenant_name }"
}

resource "openstack_compute_floatingip_v2" "ms-control-floatip" {
  pool       = "${ var.floating_pool }"
  count      = "${length(split(",", var.control_float_names))-1}"
  depends_on = [ "openstack_networking_router_v2.ms-router",
                 "openstack_networking_network_v2.ms-network",
                 "openstack_networking_router_interface_v2.ms-router-interface" ]
}

resource "openstack_compute_floatingip_v2" "ms-resource-floatip" {
  pool       = "${ var.floating_pool }"
  count      = "${length(split(",", var.resource_float_names))-1}"
  depends_on = [ "openstack_networking_router_v2.ms-router",
                 "openstack_networking_network_v2.ms-network",
                 "openstack_networking_router_interface_v2.ms-router-interface" ]
}

resource "openstack_compute_instance_v2" "control-withip" {
  floating_ip           = "${ element(openstack_compute_floatingip_v2.ms-control-floatip.*.address, count.index) }"
  name                  = "${element(split(",", var.control_float_names), count.index)}"
  image_name            = "${ var.image_name }"
  flavor_name           = "${ var.flavor_name }"
  key_pair              = "${ var.keypair_name }"
  security_groups       = [ "${ var.security_groups }" ]
  network               = { uuid = "${ openstack_networking_network_v2.ms-network.id }" }
  metadata = {
    dc = "${var.datacenter}"
    role = "worker"
   # ssh_user = "${ var.ssh_user }"
   }
  count                 = "${length(split(",", var.control_float_names))-1}"
}

resource "openstack_compute_instance_v2" "resource-withip" {
  floating_ip           = "${ element(openstack_compute_floatingip_v2.ms-resource-floatip.*.address, count.index) }"
  name                  = "${element(split(",", var.resource_float_names), count.index)}"
  image_name            = "${ var.image_name }"
  flavor_name           = "${ var.flavor_name }"
  key_pair              = "${ var.keypair_name }"
  security_groups       = [ "${ var.security_groups }" ]
  network               = { uuid = "${ openstack_networking_network_v2.ms-network.id }" }
  metadata = {
    dc = "${var.datacenter}"
    role = "worker"
  #  ssh_user = "${ var.ssh_user }"
   }
 count                 = "${length(split(",", var.resource_float_names))-1}"
}

resource "openstack_compute_instance_v2" "control" {
  name                  = "${element(split(",", var.control_names), count.index)}"
  image_name            = "${ var.image_name }"
  flavor_name           = "${ var.flavor_name }"
  key_pair              = "${ var.keypair_name }"
  security_groups       = [ "${ var.security_groups }" ]
  network               = { uuid = "${ openstack_networking_network_v2.ms-network.id }" }
  metadata = {
    dc = "${var.datacenter}"
    role = "worker"
   # ssh_user = "${ var.ssh_user }"
   }
  count                 = "${length(split(",", var.control_names))-1}"
}

resource "openstack_compute_instance_v2" "resource" {
  name                  = "${element(split(",", var.resource_names), count.index)}"
  image_name            = "${ var.image_name }"
  flavor_name           = "${ var.flavor_name }"
  key_pair              = "${ var.keypair_name }"
  security_groups       = [ "${ var.security_groups }" ]
  network               = { uuid = "${ openstack_networking_network_v2.ms-network.id }" }
  metadata = {
    dc = "${var.datacenter}"
    role = "worker"
  #  ssh_user = "${ var.ssh_user }"
   }
 count                 = "${length(split(",", var.resource_names))-1}"
}

resource "openstack_networking_network_v2" "ms-network" {
  name = "${ var.short_name }-network"
}

resource "openstack_networking_subnet_v2" "ms-subnet" {
  name          = "${ var.short_name }-subnet"
  network_id    = "${ openstack_networking_network_v2.ms-network.id }"
  cidr          = "${ var.subnet_cidr }"
  ip_version    = "${ var.ip_version }"
}

resource "openstack_networking_router_v2" "ms-router" {
  name             = "${ var.short_name }-router"
  external_gateway = "${ var.external_net_id }"
}

resource "openstack_networking_router_interface_v2" "ms-router-interface" {
  router_id = "${ openstack_networking_router_v2.ms-router.id }"
  subnet_id = "${ openstack_networking_subnet_v2.ms-subnet.id }"
}

output "net_id" {
  value = "${ openstack_networking_network_v2.ms-network.uuid }"
}

output "control_floating_id" {
  value = "${ openstack_compute_floatingip_v2.ms-control-floatip.id }"
}

output "resource_floating_id" {
  value = "${ openstack_compute_floatingip_v2.ms-resource-floatip.id }"
}