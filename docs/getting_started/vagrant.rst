Vagrant
=======

.. versionadded:: 1.0

The Mantl project ships with a ``Vagrantfile`` that you can use to provision
clusters locally.  Configuration for this option is more constrained than
terraform deployments, but with Vagrant v1.8, we support
multivm deployments with ansible_local provisioning.

Configuration is read from a file named ``vagrant-config.yml`` in the same
directory as ``Vagrantfile``. The default values are defined in this section
of the ``Vagrantfile``:

.. literalinclude:: ../../Vagrantfile
        :linenos:
        :language: ruby
        :lines: 5-20

The playbooks are executed sequentially. Each VM created in this script will
have an IP assigned based on the ``*_ip_start`` value, with that VM's "count"
appended. So, for example, if the ``worker_ip_start`` were set to
``192.168.50.30`` and it's the third worker in the count (``worker-003``), then
it's IP will be set to ``192.168.50.301``.

A minimal ``vagrant-config.yml`` file to emulate the sample terraform
configurations:

.. codeblock:: yaml

        worker_count: 3
        control_count: 3
        edge_count: 2

