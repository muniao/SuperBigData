#########################################################################
# File Name: ./work/check_server.sh
# Author: Tiakon
# mail: tiankai.me@gmail.com
# Created Time: 2018年05月05日 星期六 23时49分55秒
#########################################################################
#!/bin/bash
#Program function: To check nginx and mysql's running status
reset=$(tput sgr0)
standarndColor='\e[32m'
errorColor='\e[31m'
warnColor='\e[33m'
nginxServer=192.168.199.245/nginx_status
Mysql_Slave_Server='192.168.199.245'
Check_Nginx_Server(){

status_code=$(curl -I -m 5 -o /dev/null -s -w %{http_code} ${nginxServer})
	if [ $status_code -eq 000 -o $status_code -ge 500 ];then
  	    echo -e $warnColor "check http server error! Response status code is" $errorColor $status_code $reset
	else
	    http_content=$(curl -s ${nginxServer})
	    echo -e $standarndColor "check http server ok! \n" $reset  $http_content
	fi

}
Check_Mysql_Server(){

	# nc -z -w2 ${Mysql_Slave_Server} 3306 &>/dev/null
	# centos7 已取消 nc 中的 z 可使用以下写法代替。
	 nc -w 1  192.168.199.245 3306 < /dev/null && echo " tcp port ok" >
	 if [ $? -eq 0 ];then
 	 echo -e $standarndColor "contect ${Mysql_Slave_Server} ok!"
	 fi
}
Check_Mysql_Server
Check_Nginx_Server
