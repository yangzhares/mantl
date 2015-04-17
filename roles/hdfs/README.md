# hdfs

An Ansible role for installing [HDFS](https://hadoop.apache.org/docs/r1.0.4/cluster_setup.html)

## Role Variables

- `hdfs_version` - HDFS version (default: `2.6.0`)
- `hdfs_conf_dir` - Configuration directory for HDFS (default: `/etc/hadoop/conf`)
- `hdfs_namenode` - Flag to determine if a node is an HDFS NameNode (default: `False`)
- `hdfs_namenode_host` - Hostname of the HDFS NameNode (default: `host-01`)
- `hdfs_namenode_port` - Port of the HDFS NameNode (default: `8020`)
- `hdfs_core_properties` - A list of properties for the `core-site.xml` configuration file.
- `hdfs_namenode_host` - A list of properties for the NameNode `hdfs-site.xml` configuration file.
- `hdfs_datanode_properties` - A list of properties for the DataNode `hdfs-site.xml` configuration file.

