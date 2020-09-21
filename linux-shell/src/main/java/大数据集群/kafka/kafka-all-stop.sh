# !/bin/bash

for i in {2..4}
do
ssh test0$i 'source /etc/profile;/bin/sh /root/apps/kafka_2.11-0.10.2.1/bin/kafka-server-stop.sh -daemon /root/apps/kafka_2.11-0.10.2.1/config/server.properties &'
done
