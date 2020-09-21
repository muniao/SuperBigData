#!/bin/bash

# 从master复制内容到slave1、slave2
# scp mapred-site.xml yarn-site.xml hadoop-sny@slave1:~/bigdata/hadoop-2.7.5/etc/hadoop/
# scp mapred-site.xml yarn-site.xml hadoop-sny@slave2:~/bigdata/hadoop-2.7.5/etc/hadoop/
# 可替换成：
# cd ~/bigdata/hadoop-2.7.5/etc/hadoop/
# ~/shell/scp_all.sh mapred-site.xml
# ~/shell/scp_all.sh yarn-site.xml

prame=$1  #接收文件名
dirname=`dirname $1`
cd $dirname   #进入该文件路径下
fullpath=`pwd -P .`  #获得该文件的绝对路径
user=`whoami`    #获得当前用户的身份
 
for ip in master slave1 slave2 #循环三个主机名
do
echo ============ $ip =============
  scp -r $prame ${user}@$ip:$fullpath   
done