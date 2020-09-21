#!/bin/bash
for i in {2..4}
do
ssh test0$i 'hostname'
ssh test0$i 'source /etc/profile;/bin/sh /root/apps/zookeeper-3.4.11/bin/zkServer.sh status'
done

