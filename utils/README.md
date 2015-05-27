# Overview

Script for rotating logs in HDFS.
It uses [snakebite](https://github.com/spotify/snakebite) module to operate HDFS.

### Usage

You can run `hdfs-log-rotate.py -h` for available params.

Common usage:
```
./hdfs-log-rotate.py -n <namenode> -p <rpcport> -d <daystokeep>
```

### Example

To purge logs older than 3 days
```
./hdfs-log-rotate.py -n host-01 -p 8020 -d 3
```
Te test script you can use `--test` parameter
```
./hdfs-log-rotate.py -n host-01 -p 8020 -d 3 --test
```
It will output (not actually delete) witch files will be deleted.
