#########################################################################
# File Name: ./work/system_monitor.sh
# Author: Tiakon
# mail: tiankai.me@gmail.com
# Created Time: 2018年05月05日 星期六 23时49分40秒
#########################################################################
#!/bin/bash
#Program function: A shell script to monitor Network,Disk Usage,Uptime,Load Average,RAM Usage and CPU's Information, Temperature  in Linux.
clear
echo $0
if [[ $# -eq 0 ]]
then
# Define Variable reset_terminal
#字体颜色
#深绿
fontColor='\E[36m'
#黄色
font2Color='\E[33m'
#闪烁
hostnameColor='\E[34m'
hostnameAction='\E[5m'
#绿色
successFulColor='\E[32m'
#红色
failColor='\E[31m'
#使用终端的默认颜色 白色
reset=$(tput sgr0)

# Check OS Type
os=$(uname -o)
echo -e $fontColor "Operating System Type :" $reset $os

# Check OS Release Version and Name
relVersionName=$(cat /etc/centos-release) 
echo -e $fontColor  "OS Release Version and Name :" $reset $relVersionName

# Check Architecture CPU 的架构
arc=$(uname -m)
# 操作系统位数
osBit=$(getconf LONG_BIT)
echo -e $fontColor  "Architecture :" $reset $arc'_'$osBit

# Check Kernel Release
kernelRel=$(uname -r)
echo -e $fontColor "Kernel Release :" $reset $kernelRel

# Check hostname
# hostname=$(hostname)
# hostname=$($HOSTNAME)
hostname=$(uname -n)
echo -e $fontColor  "HostName :" $hostnameAction $hostnameColor $hostname $reset

# Check Internal IP
iip=$(hostname -I) 
echo -e $fontColor "Internal IP :"  $font2Color  $iip $reset

# Check External IP
eip=$(curl -s http://ipecho.net/plain)
echo -e $fontColor "External IP :"  $font2Color  $eip $reset

# Check DNS
# nameservers=$(awk '/nameserver/{print $2}' /etc/resolv.conf)
nameservers=$(cat /etc/resolv.conf | grep -E "\<nameserver[ ]+"| awk '{print $NF}')
echo -e $fontColor "NameServers  :" $font2Color $nameservers $reset

# Check if connected to Internet or not
ping -c 3  www.baidu.com &>/dev/null && echo -e $fontColor "Connect Status: " $successFulColor "Connected" || echo -e $fontColor "Connect Status: " $failColor "Disconnected"

# Check Logined In Users
who>/tmp/who
echo -e $fontColor "Logined In Users :"$reset && cat /tmp/who
rm -f /tmp/who

#系统内存的使用情况
system_memory_usages=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}END{print (total-free)/1024}' /proc/meminfo)
echo -e $fontColor "System Memuserages :  "$reset $system_memory_usages "M"

#应用内存的使用情况
apps_memory_usages=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/Buffers/{buffers=$2}/^Cached/{cached=$2}END{print (total-free-buffers-cached)/1024}' /proc/meminfo)
echo -e $fontColor "Apps Memuserages : "$reset $apps_memory_usages "M"

# CPU 负载情况
#loadaverge=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')
#loadaverge=$(w | grep "load average:"| awk 'BEGIN{FS="average:"}{print $2}')
loadaverge=$(w | grep 'load average' | awk '{print $8 $9 $10}')
echo -e $fontColor "Load Averge : "$reset $loadaverge

# CPU 温度
temp=$(cat /sys/class/thermal/thermal_zone0/temp)
rpi_temp=$(echo "$temp 1000" | awk '{print $1/$2}')
echo -e $fontColor "CPU Temperature : "$reset $rpi_temp "℃"

# 磁盘的使用情况
#disk_usages=$(df -h | grep -vE '文件系统|tmpfs'|awk "{print $1 $2 $4 $3 $5}")
df -hP | grep -vE 'tmpfs'>/tmp/disk_usages
echo -e $fontColor "Disk Usages : "$reset && cat /tmp/disk_usages
rm -f /tmp/disk_usages

fi
