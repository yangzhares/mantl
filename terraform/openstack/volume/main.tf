variable short_name {}
variable region {}
variable volume_size { default = 30 }
variable volume_count { default = 0 }


resource "openstack_blockstorage_volume_v1" "volume" {
  region                = "${ var.region }"
  name                  = "${ var.short_name}-volume-${format("%02d", count.index+1) }"
  size                  = "${ var.volume_size }"
  count                 = "${ var.volume_count }"
}
