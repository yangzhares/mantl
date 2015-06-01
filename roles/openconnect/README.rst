==========================
OpenConnect SSL VPN server
==========================

This ansible role deploys `OpenConnect VPN <http://www.infradead.org/ocserv/>`_ server which has (currently experimental) compatibility with clients using the AnyConnect SSL VPN.

************
Prerequisite
************

* CentOS 7
* Installed EPEL repository
* Installed Iptables service

*********
Variables
*********

Common variables
================

============================  ==================================  ==========================
Variable                      Description                         Default value
============================  ==================================  ==========================
openconnect_conf_path         path to configuration files         /etc/ocserv
openconnect_passwd_file       path to the password file           /etc/ocserv/ocpasswd
openconnect_conf_file         path to the default ocserv.conf     /etc/ocserv/ocserv.conf
openconnect_user              owner user of openconnect service   ocserv
openconnect_group             owner group of openconnect service  ocserv
openconnect_tcp_port          TCP port for service                443
openconnect_udp_port          UDP port for service                443
openconnect_chroot            chroot for ocserv process           /var/lib/ocserv
============================  ==================================  ==========================

SSL certificates variables
==========================

If you don't have any SSL certificates for the VPN server in files directory this role automatically generates CA and server private keys and certificates in .pem format.

============================  ==================================================  ============================
Variable                      Description                                         Default value
============================  ==================================================  ============================
openconnect_cert              name of the server certificate file                 server-cert.pem
openconnect_key               name of the server key file                         server-key.pem
openconnect_ca_cert           name of the CA certificate file                     ca-cert.pem
openconnect_ca_key            name of the CA key file                             ca-key.pem
openconnect_cert_path         path to the server certificate                      /etc/ocserv/server-cert.pem
openconnect_key_path          path to the server key                              /etc/ocserv/server-key.pem
openconnect_ca_cert_path      path to the CA certificate                          /etc/ocserv/ca-cert.pem
openconnect_ca_key_path       path to the CA key                                  /etc/ocserv/ca-key.pem
openconnect_ca_template       template for generating ca key and certificate      /etc/ocserv/ca.tmpl
openconnect_server_template   template for generating server key and certificate  /etc/ocserv/server.tmpl
openconnect_org               Organization field for certificate generation       "Example Inc."
============================  ==================================================  ============================


Client network variables
========================

============================  =============================  ============================
Variable                      Description                    Default value
============================  =============================  ============================
openconnect_int_net           tunnel network                 192.168.253.0
openconnect_int_mask          mask for the tunnel network    255.255.255.0
openconnect_dns               DNS server for a client        8.8.8.8
openconnect_route_list        list with injected routes      directly connected network
============================  =============================  ============================

By default OpenConnect server inject route for directly connected network to the client.
You can change this behaviour adding routes into the list. For example redefine this variable:

openconnect_route_list: [ "192.168.1.0/255.255.255.0", "172.16.0.0/255.255.0.0" ]

The client will get only routes 192.168.1.0/24 and 172.16.0.0/16

To route all client's traffic through the tunnel just define an empty list: openconnect_route_list: [ ]



Authentication
==============

This role uses authentication from file with hashed password. You can specify a list of dictionaries with username and password values.

============================  =======================================  ==================================
Variable                      Description                              Default value
============================  =======================================  ==================================
openconnect_users             List with username and password values   - {username: test, password: pass}
============================  =======================================  ==================================

********************************************************
Cisco AnyConnect Secure Mobility Client interoperability
********************************************************

To start with VPN connection just enter IP address of the VPN server and then click the Connect button.
If you have self-signed certificates you need to disable option "Block connection to untrusted servers" in the Cisco AnyConnect Secure Mobility Client settings.
