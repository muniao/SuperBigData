#!/bin/bash
 params=$@
 i=1
 
 for((i=1 ;i <=4 ;i=$i+1 ));do
 echo ==========s$i $params==========
 ssh s$i "source /etc/profile;$params"
 done

 #!/bin/bash

prame=$1  #接收文件名
dirname=`dirname $1`
basename=`basename $1`  #得到文件的basename
cd $dirname   #进入该文件路径下
fullpath=`pwd -P .`  #获得该文件的绝对路径
user=`whoami`    #获得当前用户的身份
 
for(( i = 1; i < 3; i = $i + 1 ));do  #遍历发送
echo ============ node$i =============
	scp -rv $prame  ${user}@node$i:$fullpath   
done