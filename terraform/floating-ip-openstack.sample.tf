module "dc2-floating-1" {
        source = "./terraform/openstack/floating"
        auth_url = ""
        datacenter = ""
        tenant_id = ""
        tenant_name = ""
        instance_name = ""
        flavor_name = ""
        image_name = ""
        subnet_cidr = ""
        floating_count = 
        floating_pool = ""
        external_net_id = ""

}
