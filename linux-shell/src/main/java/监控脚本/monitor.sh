#! /bin/bash

#========================================
# file: monitor.sh
# write by libin 2016/09/14
# desc: a tool for checking cpu, memory for every 5 seconds.
#========================================

# 间隔时间
SLEEP_TIME=30


if [ "$#" -lt 1 ]
then
    echo "Usage: $0 program"
    exit -1;
fi

# 第一个参数为被监控的进程ID
PID="$1"
FILTER="grep\|monitor\|ps\|top\|lsof\|pstree\|sz\|rz\|gdb"
PROCESS_NAME=$(ps -ef | grep ${PID} | grep -v ${FILTER} | awk '{print $8}' | awk -F '[/]' '{print $NF}')
# 自动抓取进程名,拼接日志文件名 [进程名]_[PID]_stress_monitoring_record.log
LOG="${PROCESS_NAME}_${PID}_stress_monitoring_record.log"

thread_num=0
open_files=0
vmem=0
mem=0
cpu_info=""


while true
do
    # 判断被监控的进程是否启动
    PRO_NOW=`ps aux | grep $PID | grep -v ${FILTER} | wc -l`
    if [ $PRO_NOW -eq 0 ]
    then 
        echo "`date +"%Y-%m-%d %H:%M:%S"`, $PID is not running!!!!!!!!!!!!!" >> ./$LOG
    else
        #线程数
        thread_num=$(pstree -p $PID | wc -l)
        #打开文件数
        open_files=$(lsof -p $PID | wc -l)
        #cpu占用率
        cpu_info=`top -bn 1 -p $PID | awk 'NR==8 {print $9}'`
        #虚拟内存使用量
        vmem=`ps aux | grep $PID | grep -v ${FILTER} | awk '{print $5}'`
        #内存使用量
        mem=`ps aux | grep $PID | grep -v ${FILTER} | awk '{print $6}'`
        #输出到日志文件
        echo -e "`date +"%Y-%m-%d\t%H:%M:%S"`\t${vmem}\t${mem}\t${cpu_info}\t${open_files}\t${thread_num}" >> ./${LOG}
    fi
    sleep $SLEEP_TIME
done
