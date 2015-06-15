# input variables
variable api_url { }
variable api_key { }
variable secret_key { }
variable keypair_name { default = "mi" }
variable public_key_filename { default = "~/.ssh/id_rsa.pub" }

provider "cloudstack" {
  api_url   = "${ var.api_url }"
  api_key    = "${ var.api_key }"
  secret_key = "${ var.secret_key }"
}

# create resources
resource "cloudstack_ssh_keypair" "default" {
  name = "${var.keypair_name}"
  public_key = "${file(var.public_key_filename)}"
}

# output variables
output "keypair_name" {
  value = "${cloudstack_ssh_keypair.default.name}"
}
