module "cs-keypair" {
  source = "./terraform/cloudstack/keypair"
  api_url = ""
  api_key = ""
  secret_key = ""
  short_name = ""
  public_key_filename = ""
}

module "cs-hosts" {
  source = "./terraform/cloudstack/hosts"
  api_url = ""
  api_key = ""
  secret_key = ""
  zone = ""
  control_name = ""
  worker_name  = ""
  network_id = ""
  template = ""
  keypair_name = "${ module.cs-keypair.keypair_name }"
  control_count = 2
  worker_count = 3
}
