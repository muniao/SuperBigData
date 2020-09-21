#!/bin/bash

#$1 : source的可选值  netcat | spoolDir 
#$2 :  sink 的可选值  logger |  hdfs | kafka

/root/apps/apache-flume-1.6.0-bin/bin/flume-ng agent -n a1  -c /root/apps/apache-flume-1.6.0-bin/conf -f /root/apps/apache-flume-1.6.0-bin/conf/$1-$2.conf -Dflume.root.logger=INFO,console
