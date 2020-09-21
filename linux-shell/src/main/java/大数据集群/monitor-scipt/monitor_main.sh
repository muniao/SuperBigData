#########################################################################
# File Name: monitor_mian.sh
# Author: Tiakon
# mail: tiankai.me@gmail.com
# Created Time: 2018年05月05日 星期六 20时46分19秒
#########################################################################
#!/bin/bash
#重置显示文字的颜色为系统默认的颜色
reset=$(tput sgr0)
# 声明关系数组
declare -A sh_array
# 统计文件的数量
i=0
numbers=""
workFile_path="/root/work/"
for script_file in $(ls -I 'monitor_main.sh'  /root/work)
do
   echo -e '\e[1;31m' "The Script:" ${i} '==>' ${reset} ${script_file}
   grep -E "^\#Program function" ${workFile_path}${script_file}
   sh_array[$i]=${script_file}
   numbers="${numbers} | ${i}"
   # echo ${sh_array[$i]}
   i=$((i+1))
done
#echo ${numbers}

while true
do
  read -p "Please input a number [ ${numbers} ]:" input_num
  echo ${input_num}
  if [[ ! ${input_num} =~ ^[0-9]+ ]];then
      exit 0
  fi
  /bin/bash /root/work/${sh_array[$input_num]}
done
