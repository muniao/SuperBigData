#!/bin/bash
#设置java环境变量
export JAVA_HOME=/soft/jdk
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH = ${JAVA_HOME}/bin:$PATH

#设置hadoop环境变量
export HADOOP_HOME=/soft/hadoop
export PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH

#日志文件存放的目录
log_src_dir=/home/hadoop/logs/log/

#待上传的日志存放目录
log_toupload_dir=/home/hadoop/logs/toupload/

#日志文件上传到hdfs上的目录
hdfs_log_dir=/data/clickLog/2017/

#打印环境变量信息
echo "envs:hadoop_home: $HADOOP_HOME"

#读取日志文件的目录，判断是否有需要上传的文件
echo "log_src_dir: $log_src_dir"
ls $log_src_dir | while read fileName
do
    if[["$fileName" == access.log.*]] then
        date=`date+%Y_%m_%d_%H_%M_%S`
        #将文件移动到待上传的目录中并重命名
        #打印信息
        echo "moving $log_src_dir$fileName to $log_toupload_dir"xxxx_click_log_$fileName"$date"
        mv $log_src_dir$fileName $log_toupload_dir"xxxx_click_log_$fileName"$date
        #将待上传的文件path写入一个列表文件willDoing中
        echo $log_toupload_dir"xxxx_click_log_$fileName"$date >> $log_toupload_dir"willDoing."$date
    fi
done

#找到列表文件willDoing
ls $log_toupload_dir | grep will | grep -v "_COPY_" | grep -v "_DONE_" | while read line
do
    #打印信息
    echo "toupload is in file":$line
    #将待上传文件列表willDoing文件改为willDoing_COPY_
    mv $log_toupload_dir$line $log_toupload_dir$line"_COPY_"
    #读列表文件willDoing_COPY_的内容（一个一个待上传文件内容），此处的line就是列表中的待上传文件
    cat $log_toupload_dir$line"_COPY_" | while read line
    do
        #打印信息
        echo "putting ... $line to hdfs path... $hdfs_log_dir"
        hadoop fs -put $line $hdfs_log_dir
    done
    mv $log_toupload_dir$line"_COPY_" $log_toupload_dir$line"_DONE_"
done