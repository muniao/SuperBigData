#!/bin/bash
echo "hiveserver2 try running..."
/root/apps/apache-hive-1.2.2-bin/bin/hiveserver2 1>/dev/null 2>&1 &
status=$?
if [[ $status != 0 ]]
 then 
 echo status is $status
 echo "hiveserver2 run failed!" 
elif [[ $status = 0 ]]
 then
 echo status is $status
 echo "hiveserver2 is listening..." 
 echo "request client conection..." 
 /root/apps/apache-hive-1.2.2-bin/bin/beeline -u jdbc:hive2://test03:10000 -n root
 echo "successful"
fi
echo "end"
