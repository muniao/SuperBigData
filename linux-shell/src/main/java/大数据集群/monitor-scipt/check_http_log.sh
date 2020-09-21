#########################################################################
# File Name: ./work/check_http_log.sh
# Author: Tiakon
# mail: tiankai.me@gmail.com
# Created Time: 2018年05月05日 星期六 23时49分21秒
#########################################################################
#!/bin/bash
#Program function: Nginx's log analysis

reset=$(tput sgr0)
fontColor="\E[33m"
logfile_path="/usr/local/nginx/logs/access.log"

Check_http_status(){

http_statu_codes=(`cat /usr/local/nginx/logs/access.log|grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}"|awk -F"[ ]+" '{
		if($2>100&&$2<200) {i++}
		else if($2>=200&&$2<300){j++}
		else if($2>=300&&$2<400){k++}
		else if($2>=400&&$2<500){n++}
		else if($2>=500){p++}
		}END{print i?i:0,j?j:0,k?k:0,n?n:0,p?p:0,i+j+k+n+p}'
		`) 
echo -e $fontColor "The number of http status[100+]: " $reset ${http_statu_codes[0]}
echo -e $fontColor "The number of http status[200+]: " $reset ${http_statu_codes[1]}
echo -e $fontColor "The number of http status[300+]: " $reset ${http_statu_codes[2]}
echo -e $fontColor "The number of http status[400+]: " $reset ${http_statu_codes[3]}
echo -e $fontColor "The number of http status[500+]: " $reset ${http_statu_codes[4]}
echo -e $fontColor "All request numbers: " $reset ${http_statu_codes[5]}
}
Check_http_code(){

Http_Code=(`cat /usr/local/nginx/logs/access.log|grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}" |awk -v total=0 -F '[ ]+' '{
		if ($2!=""){code[$2]++;total++}
		else {exit}
		}END{print code[304]?code[304]:0,code[404]?code[404]:0,code[403]?code[403]:0,total
	      }'
	  `)

echo -e $fontColor "The number of http status[304]" $reset ${Http_Code[0]}
echo -e $fontColor "The number of http status[404]" $reset ${Http_Code[1]}
echo -e $fontColor "The number of http status[403]" $reset ${Http_Code[2]}
echo -e $fontColor "All request numbers: " $reset ${Http_Code[3]}
}
Check_http_status
Check_http_code
