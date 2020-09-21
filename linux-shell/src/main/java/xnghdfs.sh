#!/bin/bash
hadoop_home=/opt/hadoop-2.4.0
tw_nginx_home=/var/www/nginx_0
cn_nginx_home=/var/www/nginx1
current_date=$(date +%Y%m%d)


echo "hadoop_home = $hadoop_home"
echo "tw_nginx_home = $tw_nginx_home"
echo "cn_nginx_home = $cn_nginx_home"
 
function putTodayLogToHdfs(){
  $hadoop_home/bin/hdfs dfs -mkdir /user/day-$current_date
  $hadoop_home/bin/hdfs dfs -mkdir /user/day-$current_date/tw-log
  $hadoop_home/bin/hdfs dfs -mkdir /user/day-$current_date/cn-log
  $hadoop_home/bin/hdfs dfs -put $tw_nginx_home/logs/access.log /user/day-$current_date/tw-log
  $hadoop_home/bin/hdfs dfs -put $cn_nginx_home/logs/access.log /user/day-$current_date/cn-log
}
#if param value:str=20141212,days=7,so return 20141205
function addDate(){
  str=$1
  days=$2
  yy=`echo $str|cut -c 1-4`
  mm=`echo $str|cut -c 5-6`
  dd=`echo $str|cut -c 7-8`
  sav_dd=$days
  days=`expr $days - $dd`
  while [ $days -ge 0 ]
  do
        mm=`expr $mm - 1`
        [ $mm -eq 0 ] && mm=12 && yy=`expr $yy - 1`
        aaa=`cal $mm $yy`
        bbb=`echo $aaa|awk ‘{print $NF}‘`
        days=`expr $days - $bbb`
  done
  dd=`expr 0 - $days`
  expr $dd : "^.$" > /dev/null && dd=0$dd
  expr $mm : "^.$" > /dev/null && mm=0$mm
  echo $yy$mm$dd
  return $yy$mmSdd
}


function removeLastWeekLog(){
  remove_date=$(addDate $current_date 7)
  echo "start remove history log file,remove date is $remove_date"
  $hadoop_home/bin/hdfs dfs -rm -r /user/day-$remove_date
}


echo "start put local log to hdfs"
putTodayLogToHdfs;
removeLastWeekLog;