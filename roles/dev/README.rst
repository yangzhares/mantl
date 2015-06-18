Dev
===

Install all the needed development software on the edge node.

Please note that you will also need to install hdfs-standalone, spark
and kafka roles.

Variables
---------

N/A

Example Playbook
----------------

.. code-block:: yaml+jinja

    ---
    - hosts: dc1:&dev
      gather_facts: no
      roles:
        - dev
        - {role: hdfs-standalone, hdfs_namenode: false, hdfs_datanode: false}
        - spark

    - hosts: dc1:&dev
      gather_facts: yes
      roles:
        - kafka
