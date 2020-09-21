#!/bin/bash

# $1 指定主题副本
# $2 指定分区个数
# $3 指定主题名称

/root/apps/kafka_2.11-0.10.2.1/bin/kafka-topics.sh --create --zookeeper test02:2181,test03:2181,test04:2181 --replication-factor $1 --partitions $2 --topic $3
