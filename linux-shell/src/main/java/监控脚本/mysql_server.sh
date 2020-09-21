#!/bin/bash

# ubuntu的默认shell由bash改为了dash，上述脚本输出时会出现两个错误。1，declare not found; 2，echo 后面的颜色配置内容都给输出。

# 三种解决方法：
# 执行时由sh build.sh变成bash build.sh
# ln -s /bin/bash /bin/sh -f
# sudo dpkg-reconfigure dash 进行配置

Mysql_Slave_Server='172.18.252.122'
Chcek_Mysql_Server(){
   nc -z -w2 ${Mysql_Slave_Server} 3306 &>/dev/null
   if [ $? -eq 0 ];then
   echo "Connect ${Mysql_Slave_Server} OK!"
   fi
}
Chcek_Mysql_Server

