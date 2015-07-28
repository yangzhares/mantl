Create Mesos Cluster
====================

Purpose
-------

Creation of Mesos Cluster from scratch in one datacenter using microservices-infrastructure project.

Pre-requisites
--------------

All steps from `Provision Open Stack Cluster <provision_open_stack_cluster.rst>`_ have been done.

Step-by-step Guide
------------------

1. Run::

        ./security-setup --mesos-framework-auth=false --mesos-iptables=false

   The script will ask for admin password for all the UIs (Mesos, Marathon and Consul).

2. Add additional users (if needed):

   Edit `inventory/group_vars/all/users.yml`.  Add all the needed users and their public keys.

3. If  particular Spark package is required ("spark-1.3.1-bin-hadoop2.6" is set
   by default), then edit `roles/spark/defaults/main.yml` and set::

        spark_default_package: "<package name>"

   For example::

        spark_default_package: "spark-1.3.0-bin-hadoop2.4"

   If different version of Spark is required, then run the command below
   on the client machine::

        source /opt/<correct spark folder>/conf/spark-env.sh

   For example::

        source /opt/spark-1.3.0-bin-hadoop2.4/conf/spark-env.sh

   Note: This shell script will change Spark version only for the current user session and only on temporary basis.

   In order to change permanently Spark version run command::

        sudo ln -s /opt/<correct spark folder> /opt/spark

   For example::

        sudo ln -s /opt/spark-1.3.0-bin-hadoop2.4 /opt/spark

   Before kakfa-mesos application is installed, the number of created and running brockers can be changed.

           Edit variable kafka_brokers: "<number>" in roles/kafka-mesos/defaults/main.yml

  In order to enable brocker installation process variable enable_client_install should be set to "true".
  In case of "false" value, no brockers will be installed.

  In order to repair kafka-mesos-scheduler application, variable repair must be set to "true". Default value is "false"

  WARNING:: When repair is set to "true", all existing brockers are destroyed and kafka-mesos-scheduler application
            is removed from Marathon.

4. The next step is to run the main playbook with security file generated before::

        ansible-playbook -i inventory/<inventory file> site.yml -e @security.yml

5. Verify all the services (use "admin" as the user name and the password set for
   `security-setup`):

   *Mesos:*

   Open *https://<any mesos_leader>:5050*

   Open *https://<any mesos_leader>:5050/state.json*

   Open *https://<any mesos_leader>:5050/stats.json*

   *Consul:*

   Open *https://<any consul_server>:8500* and make sure that all services are passing

   *Marathon:*

   Open *https://<any marathon_server>:8080*.  Click "+ New App" and create some
   test application (for example, id: "sleep" and command: "sleep 3600").

   Note: In case of error "Secure Connection Failed" in Firefox browser, please try
   another one (for example, Google Chrome).

6. Verify HDFS:

   Make SSH connection to any edge node (see "dev" role in an inventory file) using
   "centos" user and run::

        hdfs dfs -ls /

   Output should be the following::

        drwxr-xr-x   - hdfs supergroup          0 2015-04-24 14:30 /apps
        drwxrwxrwx   - hdfs supergroup          0 2015-04-24 14:37 /tmp
        drwxr-xr-x   - hdfs supergroup          0 2015-04-24 14:30 /user

   Put any file on HDFS::

        hdfs dfs -put <file>
        hdfs dfs -ls

   Make sure the file is there.

7. Verify Spark:

   Make SSH connection to any edge node (see "dev" role in an inventory file) using
   "centos" user and run::

        spark-shell

   Spark shell should successfully start::

        scala>

   Then perform the following commands::

        val data = 1 to 10000
        val distData = sc.parallelize(data)
        val filteredData = distData.filter(_< 10)
        filteredData.collect()

   Output should be the following::

        res0: Array[Int] = Array(1, 2, 3, 4, 5, 6, 7, 8, 9)

   Make sure that `/tmp/test` doesn't exist on HDFS yet. Run::

        filteredData.saveAsTextFile("hdfs:///tmp/test")

   The command should finish without errors.  Exit Spark shell::

        exit

   Run::

        hdfs dfs -cat /tmp/test/part-00000

   Output should be the following::

        1
        2
        3
        4
        5
        6
        7
        8
        9

   Run::

        run-example SparkPi

   The following output must be::

        Pi is roughly 3.14336

8. Verify Kafka-mesos utility:

   Make SSH connection to any edge node (see "dev" role in inventory file)
   using "centos" user and run::

        cd /opt/kafka-mesos

   The next step is to run::

        ./kafka-mesos.sh status

   The following output must be::

        Cluster status received

        cluster:
          brokers:
            id: 0
            active: true
            state: running
            resources: cpus:0.50, mem:512, heap:256
            failover: delay:10s, max-delay:60s
            task:
              id: broker-0-67e702ad-c719-493e-8e19-95ecb8151dec
              state: running
              endpoint: host-04:4001
              attributes: node_id=host-04

        <next output is omitted>

   Note: the number of Kafka brokers and their mem/heap values depend on configuration
   file `roles/kafka/defaults/main.yml` inside project directory.

9. Verify basic Kafka functionality:

    Connect via SSH to any edge node (see "dev" role in inventory file)
    using "centos" user.  Create a topic named "test" with a single partition and one replica::

        kafka-topics.sh --create --zookeeper zookeeper.service.consul:2181 --replication-factor 1 --partitions 1 --topic test

    Output should be the following::

        Created topic "test".

    Check that new topic is created by running list topic command::

        kafka-topics.sh --list --zookeeper zookeeper.service.consul:2181

    Output should be the following::

        test

    Run the producer and then type a few messages into the console.  Instead of
    `<endpoint>` use any Kafka broker endpoint received from step 9.  It would be
    something like `host-04:4001` or similar::

        kafka-console-producer.sh --broker-list <endpoint> --topic test
        message one
        message two

    Run the consumer that will dump out messages to standard output::

        kafka-console-consumer.sh --zookeeper zookeeper.service.consul:2181 --topic test --from-beginning

    Output should be the following::

        message one
        message two

    Note: If every of the commands above (producer and consumer) is running
          in a different terminals then messages typed into the producer terminal
          appears in the consumer terminal.
