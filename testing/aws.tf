provider "aws" {
  region = "eu-central-1"
}

module "aws-drone-testing" {
  source = "./terraform/aws"
  availability_zone = "eu-central-1a"
  ssh_username = "centos"
  source_ami = "ami-61bbf104"
  short_name = "drone-ci"
  long_name = "ciscocloud-drone-ci"

  control_count = 3
  worker_count = 3
  edge_count = 2
}
