#!bin/bash
#options  -s
#signal   stop | reopen | reload

options="$1"
signal="$2"

if [[ $options == "-s" && $signal == "stop" || $signal == "reopen"  || $signal == "reload" ]]
 then
   /usr/local/nginx/sbin/nginx $options $signal
   echo "options is $options"
   echo "nginx is $signal..."
 elif [[ $options == "" && $signal == "" ]]
  then
   echo "nginx is start..."
   /usr/local/nginx/sbin/nginx
 else
   echo " arguments error! "
   echo " arguments error! "
   echo " arguments error! "
fi
