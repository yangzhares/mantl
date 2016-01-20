variable "build_number" {}

module "drone-ci-keypair" {
  source = "./terraform/openstack/keypair"
  keypair_name = "drone-ci-${var.build_number}-key"
}

module "drone-ci-hosts-floating" {
  source = "./terraform/openstack/hosts-floating"
  datacenter = "drone-ci-${var.build_number}"
  control_flavor_name = "CO2-Medium"
  worker_flavor_name  = "CO2-Medium"
  edge_flavor_name  = "CO2-Medium"
  image_name = "CentOS-7"
  ssh_user = "centos"
  keypair_name = "${ module.drone-ci-keypair.keypair_name }"
  control_count = 3
  worker_count = 3
  edge_count = 2
  floating_pool = "public-floating-601"
  control_data_volume_size = 20
  worker_data_volume_size = 100
  edge_data_volume_size = 20
}
