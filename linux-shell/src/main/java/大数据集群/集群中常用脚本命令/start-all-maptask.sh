#!/bin/bash
cpth=`find /root/apps/hadoop-2.8.1/share/ -name "*.jar" | xargs | sed "s/ /:/g"`
#maptask is running

ssh test01 "source /etc/profile;java -cp /root/wordcount.jar:$cpth cn.tiakon.hadoop.hdfs.wordcount.YarnChild maptask 0 a.txt"
ssh test02 "source /etc/profile;java -cp /root/wordcount.jar:$cpth cn.tiakon.hadoop.hdfs.wordcount.YarnChild maptask 1 b.txt"
ssh test03 "source /etc/profile;java -cp /root/wordcount.jar:$cpth cn.tiakon.hadoop.hdfs.wordcount.YarnChild maptask 2 c.txt"
ssh test04 "source /etc/profile;java -cp /root/wordcount.jar:$cpth cn.tiakon.hadoop.hdfs.wordcount.YarnChild maptask 3 d.txt"

#reducetask is running

ssh test03 "source /etc/profile;java -cp /root/wordcount.jar:$cpth cn.tiakon.hadoop.hdfs.wordcount.YarnChild reducetask 0 null"
ssh test04 "source /etc/profile;java -cp /root/wordcount.jar:$cpth cn.tiakon.hadoop.hdfs.wordcount.YarnChild reducetask 1 null"
