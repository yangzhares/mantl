variable "secret_key" { }
variable "ipv4_address" { }
variable "network_ipv4" {default = "10.0.0.0/16"}
variable "control_count" { default = "3"}
variable "worker_count" { default = "1"}
variable "control_type" { default = "small" }
variable "worker_type" { default = "small" }
variable "zone" { default = "dc1" }
variable "long_name" { default = "microservices-infastructure" }
variable "short_name" { default = "mi" }
variable "ssh_username"  { default = "centos" }
variable "ssh_key" { default = "~/.ssh/id_rsa.pub" }


provider "cloudstack" {
  api_url   = "${ var.api_url }"
  api_key    = "${ var.api_key }"
  secret_key = "${ var.secret_key }"
}

resource "cloudstack_vpc" "main" {
    name = "${ var.long_name }"
    cidr = "${ var.network_ipv4 }"
    vpc_offering = "${ var.long_name }"
    zone = "${ var.zone }"
}

resource "cloudstack_instance" "mi-control-nodes" {
  zone = "${ var.zone }"
  service_offering = "${ var.control_type }"
  template = "centos-7"
  name = "${ var.short_name }-control-${ format("%02d", count.index+1) }"
  network = "${cloudstack_network.default.id}"
  count = "${ var.control_count }"
}

resource "cloudstack_instance" "mi-worker-nodes" {
  zone = "${ var.zone }"
  service_offering = "${ var.worker_type }"
  template = "centos-7"
  name = "${ var.short_name }-worker-${ format("%02d", count.index+1) }"
  network = "${cloudstack_network.default.id}"
  count = "${ var.worker_count }"
}

resource "cloudstack_network" "default" {
  name = "${ var.short_name }-network-${ format("%02d", count.index+1) }"
  cidr = "${ var.network_ipv4 }"
  network_offering = "Default Network"
  zone = "${ var.zone }"

}

resource "cloudstack_firewall" "default" {
  ipaddress = "${ var.ipv4_address }"

  rule {
    source_cidr = "0.0.0.0/0"
    protocol = "tcp"
    ports = ["22", "80", "8080", "8500", "5050"]
  }
  rule {
    source_cidr = "0.0.0.0/0"
    protocol = "icmp"
    ports = ["0-65000"]
  }
}
