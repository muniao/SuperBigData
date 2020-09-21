#!/bin/bash

############################################################
# 内存使用
# system_memory_usage=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}END{print (total-free)/1024}' /proc/meminfo)
# echo -e '\e[32m' "system memory usage:" $reset_terminal $system_memory_usage
# 有两个cache，匹配第一个
# app_memory_usage=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{print (total-free-cached-buffers)/1024}' /proc/meminfo)
# echo -e '\e[32m' "apps memory usage:" $reset_terminal $app_memory_usage

###########################################################
# CPU
# loadaverage=$(top -n 1 -b | grep "load average" | awk '{print $10  $11  $12}')
# echo -e '\e[32m' "load averages " $reset_terminal $loadaverage
# 磁盘
# diskaverage=$(df -h | grep -vE 'Filesystem|tmpfs' | awk '{print $1 " " $5}')
# echo -e '\e[32m' "disk averages " $reset_terminal $diskaverage

# 清屏
clear
# $# 可提取位置参数个数 注意 [] 与内容之间都要有空格
if [[ $# -eq  0 ]]
then
# 定义变量
reset_terminal=$(tput sgr0)
# check OS type
os=$(uname -o)
echo -e '\e[1;32m' "Operating System Type: " $reset_terminal $os
# check OS release version and name
os_name=$(cat /etc/issue)
# os_name=$(cat /etc/issue|grep -e "Server")
echo -e '\e[1;32m' "release version and name: " $reset_terminal $os_name
# check architecture
architecture=$(uname -m)
echo -e '\e[1;32m' "architecture Type: " $reset_terminal $architecture
# check kernel release
kernel=$(uname -r);
echo -e '\e[1;32m' "kernel Type: " $reset_terminal $kernel
# check hostname
hostname=$(uname -n)
echo -e '\e[1;32m' "hostname: " $reset_terminal $hostname
# hostname=$(hostname)
# hostname=$(echo $HOSTNAME)

# check internal IP
internalIP=$(hostname -I)
echo -e '\e[1;32m' "internalIP: " $reset_terminal $internalIP
# check external IP
externalIP=$(curl -s http://ipecho.net/plain)
echo -e '\e[1;32m' "externalIP: " $reset_terminal $externalIP
# check DNS
# -E 支持元字符  加边界匹配，匹配以<nameserver开头，后面跟任意多个空格的内容
# 使用awk做列筛选，$NF 表示以空格作为分隔符，打印出最后一列
# 注意单双引号的使用
DNS=$(cat /etc/resolv.conf |grep -E "\<nameserver[ ]+" | awk '{print $NF}')
echo -e '\e[1;32m' "DNS: " $reset_terminal $DNS
# check internet connection status
# ping -c 表示次数
# 输出到空设备  &>/dev/null
ping -c 2 baidu.com &>/dev/null && echo "Internet connected" || echo "Internet disconnected"
# check LoggedIn users
who>/tmp/who
echo -e '\e[1;32m' "LoggedIn users: " $reset_terminal && cat /tmp/who
# 用完及时删除
rm -rf /tmp/who
fi