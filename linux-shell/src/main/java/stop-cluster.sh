#! /bin/bash
 
echo "------正在关闭集群------"
echo "------正在关闭Hbase------"
'/home/grid/hbase/bin/stop-hbase.sh'
 
echo "------正在关闭Spark------"
'/home/grid/spark/sbin/stop-all.sh'
 
echo "------正在关闭Hadoop-----"
'/home/grid/hadoop/sbin/stop-all.sh'
 
echo "------正在关闭Zookeeper------"
'/home/grid/zookeeper/bin/zkServer.sh stop'
ssh grid@Slave1 '/home/grid/zookeeper/bin/zkServer.sh stop'
ssh grid@Slave2 '/home/grid/zookeeper/bin/zkServer.sh stop'
 
echo "------集群关闭完成,检查是否关闭成功------"