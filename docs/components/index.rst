Components
==========

Microservices Infrastructure is made up of a number of components
which can be customized, generally using Ansible variables.

.. toctree::
   :maxdepth: 1

   collectd.rst
   consul.rst
   dnsmasq.rst
   docker.rst
   haproxy.rst
   dev.rst
   external-drives.rst
   haproxy.rst
   hdfs-standalone.rst
   kafka-mesos.rst
   kafka.rst
   logstash.rst
   marathon.rst
   mesos.rst
   spark.rst
   zookeeper.rst

The project also includes a number of Ansible roles that multiple components can
use:

.. toctree::
   :maxdepth: 1

   common.rst
   consul-template.rst
   logrotate.rst
   nginx.rst

The following technology previews are also included. These may be used more
fully in the future, but now just exist for preview purposes to gather feedback
and build initial implementations against:

.. toctree::
   :maxdepth: 1

   vault.rst
