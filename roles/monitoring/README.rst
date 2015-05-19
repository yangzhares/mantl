.. versionadded:: 0.1

`Collectd <collectd https://collectd.org>`_ connects to
:doc:`mesos`, :doc:`docker` and host OS via Python modules, and collects their performance/health metrics which then are sent to specified logging host.

Variables
---------

.. data:: logging_host

   default: ``{{ ansible_ssh_host }}``

   Host to receive collected metrics.

.. data:: logging_host_port

   default: ``25826``

   UDP port of logging_host

.. data:: mesos_master_host

   default: ``localhost``

   Host to get Mesos master metrics port. 

.. data:: mesos_master_port

   default: ``15050``

   Mesos master HTTP API port.

.. data:: mesos_slave_host

   default: ``localhost``

   Host to get Mesos slave metrics port. 

.. data:: mesos_slave_port

   default: ``15050``

   Mesos slave HTTP API port.
          

  
.. _monitoring-example-playbook:


Example Playbook
----------------

.. code-block:: yaml+jinja

    ---
    - hosts: all
      roles:
        - monitoring

