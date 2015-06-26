Spark
=====

`Apache Spark <https://spark.apache.org/>`_ is a fast and general engine for big
data processing, with built-in modules for streaming, SQL, machine learning and
graph processing.

Variables
---------

- `spark_packages` - Spark packages to be installed (default:
  `["spark-1.2.1-bin-hadoop2.4", "spark-1.2.2-bin-hadoop2.4", "spark-1.3.0-bin-hadoop2.4", "spark-1.3.1-bin-hadoop2.6", "spark-1.4.0-bin-hadoop2.6"]`).
- `spark_default_package` - Default Spark package to use (default: `spark-1.3.0-bin-hadoop2.4`).
- `spark_install_dir` - Local directory where to put Spark binary and Spark
  client (default: `/opt/spark`).
- `spark_mesos_lib` - Path to `libmesos.so` (default:
  `/usr/local/lib/libmesos.so`).
- `zookeeper_master` - Hostname of Zookeeper master (default:
  `zookeeper.service.consul`).
- `spark_log4j_host` - Hostname for logstash server (default: `localhost`).
- `spark_log4j_port` - Port for logstash server (default: `4560`).

Example Playbook
----------------

.. code-block:: yaml+jinja

    ---
    - hosts: spark
      gather_facts: no
      roles:
        - spark
