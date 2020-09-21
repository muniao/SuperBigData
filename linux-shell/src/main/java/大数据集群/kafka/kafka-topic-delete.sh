#!bin/bash
#$1 查看的主题
/root/apps/kafka_2.11-0.10.2.1/bin/kafka-topics.sh --delete --zookeeper test02:2181 --topic $1
