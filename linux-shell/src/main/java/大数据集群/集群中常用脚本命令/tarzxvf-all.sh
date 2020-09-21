#!/bin/bash

for i in {3..4}
do
ssh test0$i "source /etc/profile;tar -zxvf spark-2.3.0-bin-hadoop2.7.tgz -C /root/apps/" 
done
