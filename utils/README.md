# Overview

This Python script uses snakebite module to operate HDFS.

You can run `hdfs-log-rotate.py -h` for available params.

Common usage:
```
./hdfs-log-rotate.py -n <namenode> -p <rpcport> -d <daystokeep>
```

### Example
```
./hdfs-log-rotate.py -n host-01 -p 8020 -d 3
```
