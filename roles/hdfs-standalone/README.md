# HDFS

An Ansible role for installing [HDFS](https://hadoop.apache.org/docs/r1.0.4/cluster_setup.html)

## Variables

- `hdfs_version` - HDFS version (default: `2.6.0`)
- `hdfs_conf_dir` - Configuration directory for HDFS (default: `/etc/hadoop/conf`)
- `hdfs_install_dir` - Directory where to install HDFS (default: `/usr/local/share`)
- `hdfs_namenode` - Flag to determine if a node is an HDFS NameNode (default: `False`)
- `hdfs_namenode_host` - Hostname of the HDFS NameNode (default: `localhost`)
- `hdfs_namenode_port` - Port of the HDFS NameNode (default: `8020`)
- `hdfs_hadoop_opts` - Extra Java runtime options for Hadoop (default: `-Djava.net.preferIPv4Stack=true`)
- `hdfs_core_properties` - A list of properties for the `core-site.xml` configuration file.
- `hdfs_namenode_properties` - A list of properties for the NameNode `hdfs-site.xml` configuration file.

## Example Playbook

    ---
    - hosts: name_node
      gather_facts: no
      roles:
        - hdfs-standalone

    - hosts: data_nodes
      gather_facts: no
      roles:
        - hdfs-standalone
