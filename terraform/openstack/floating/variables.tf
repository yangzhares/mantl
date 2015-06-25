module "dc2-hosts-floating" {
        source = "./tmp"
        auth_url = "https://us-internal-1.cloud.cisco.com:5000/v2.0"
        keypair_name = "ansible_key_dvakulov"
        datacenter = "dc2"
        tenant_id = "fc86ff9d79cd4440aeb35f2a1004a6cc"
        tenant_name = "CCS-MI-US-INTERNAL-1-QA-3"
        flavor_name = "Micro-Small"
        image_name = "centos-7_x86_64-2015-01-27-v6"
        floating_pool = "public-floating-601"
        external_net_id = "ca80ff29-4f29-49a5-aa22-549f31b09268"
##
#       Variables for resource and control groups to assign floating IP
##
        control_float_names = "mi-control-01,"
        resource_float_names = "mi-worker-01,mi-worker-03,"
##
#       Variables for nodes without floating IP
##
        control_names = "mi-control-02,mi-control-03,"
        resource_names = "mi-worker-02,"
}              