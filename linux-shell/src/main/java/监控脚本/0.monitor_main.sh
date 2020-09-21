#!/bin/bash
resettem=$(tput sgr0)
# 定义关联数组存储 键：数字,脚本号码   值：脚本名
DECLARE -A ssharray
i=0
numbers=""

# 使用for循环遍历所有子功能shell并输出(需要排除本文件) 注意单引号和双引号的使用
for script_file in `ls -I "monitor_main.sh" ./`
do
    echo -e "\e[1;35m" "The Script:" ${i} '==>' ${ressettem} ${script_file}
    # 关联数组赋值
    ssharray[$i]=${script_file}
    # echo ${ssharray[$i]}
    numbers="${numbers} | $i"
    i=$((i+1))
done
# echo ${numbers}
# 写一个无限循环
while true
do
  # 输入提示
  read -p "Please input a number [ ${numbers} ]:"  execshell
  # echo ${execshell}
  # 如果输入内容不是数字，中断
  if [[ ! ${execshell} =~ ^[0-9]+ ]];  then
     exit 0
  fi

  # 如果输入正确，执行对应的脚本
  /bin/bash ./${ssharray[$execshell]}
done