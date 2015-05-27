#!/usr/bin/env python

import argparse
import time
from datetime import datetime, timedelta
from snakebite.client import Client

parser = argparse.ArgumentParser(description='Purge logs in HDFS older than X days.')

parser.add_argument('-n', '--namenode', type=str, default='host-01', help='DNS name of the HDFS cluster namenode (Default: host-01)')
parser.add_argument('-p', '--rpcport', type=int, default=8020, help='HDFS RPC port (Default: 8020)')
parser.add_argument('-d', '--daystokeep', type=int, default=3, help='Number of days to keep log files (Default: 3)')
parser.add_argument('--test', action='store_true', default=False, help='Do not delete any files, output files to delete instead.')

args = parser.parse_args()

now = time.time()
hdfsc = Client(args.namenode, args.rpcport, use_trash=False)
filestodelete = []

for host in hdfsc.ls(['/logs/']):
    for logfile in hdfsc.ls([host.get('path')]):

     	logfilepath = logfile.get('path')
	    logfilets = logfile.get('modification_time')
        logfilets = str(logfilets)
        logfilets = logfilets[:-3]

        if ((datetime.fromtimestamp(int(now))) - (datetime.fromtimestamp(int(logfilets)))) > timedelta(days=args.daystokeep):
            if args.test:
                print("Delete this file: {}" .format(logfilepath))
            else:
                filestodelete.append(logfilepath)
        else:
            if args.test:
                print("Keep this file: {}" .format(logfilepath))

if not args.test and filestodelete:
    result = hdfsc.delete(filestodelete)
    for item in result:
        print("File: {:<50}\t Removed: {}" .format(item.get('path'), item.get('result')))

print("Done!")
