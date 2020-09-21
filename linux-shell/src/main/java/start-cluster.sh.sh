
#! /bin/bash
 
echo "------正在启动集群------"
echo "------正在启动Zookeeper------"
'/home/grid/zookeeper/bin/zkServer.sh start'
ssh grid@Slave1 '/home/grid/zookeeper/bin/zkServer.sh start'
ssh grid@Slave2 '/home/grid/zookeeper/bin/zkServer.sh start'
 
echo "------正在启动Hadoop-----"
'/home/grid/hadoop/sbin/start-all.sh'
 
echo "------正在启动Spark------"
'/home/grid/spark/sbin/start-all.sh'
 
echo "------正在启动Hbase------"
'/home/grid/hbase/bin/start-hbase.sh'
 
echo "------正在启动Hive-------"
ssh grid@Slave1 '/home/grid/hive/bin/hive --service metastore &'
ssh grid@Slave1 '/home/grid/hive/bin/hive --service hiveserver2 &'
 
