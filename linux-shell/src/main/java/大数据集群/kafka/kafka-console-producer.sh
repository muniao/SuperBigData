#!/bin/bash
# $1 生产数据的主题。
/root/apps/kafka_2.11-0.10.2.1/bin/kafka-console-producer.sh --broker-list test02:9092,test03:9092,test04:9092 --topic $1
