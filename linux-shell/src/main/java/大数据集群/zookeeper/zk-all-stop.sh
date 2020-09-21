#!/bin/bash
echo 'zookeeper-3.4.11 is end...'
for i in {2..4}
do 
ssh test0$i '/root/apps/zookeeper-3.4.11/bin/zkServer.sh stop'
done
