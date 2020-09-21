#!/bin/bash

# 显示：/var/log/nginx
# 精确正则：cat /var/log/nginx/access.log | grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}"
# 状态码：cat /var/log/nginx/access.log | awk '{print $9}' | sort | uniq -c | sort -rn | more
# 统计+排序：cat /var/log/nginx/access.log | awk '{print $1}' | sort | uniq -c | sort -rn | more
# 明细：122.13.162.25 - - [31/Jul/2020:19:12:24 +0800] "GET / HTTP/1.1" 200 22462 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" "-"

resettem=$(tput sgr0)
Logfile_path='/var/log/nginx/access.log'
Check_http_status() {
Http_status_codes=(`cat $Logfile_path|grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}"|awk -F"[ ]+" '{
if($2>100&&$2<200)
{i++}
else if($2>=200&&$2<300)
{j++}
else if($2>=300&&$2<400)
{k++}
else if($2>=400&&$2<500)
{n++}
else if($2>=500)
{p++}
}END{
print i?i:0,j?j:0,k?k:0,n?n:0,p?p:0,i+j+k+n+p
}'
`)
echo -e '\E[33m' "The number of http status[100+]:" ${resettem} ${Http_status_codes[0]}
echo -e '\E[33m' "The number of http status[200+]:" ${resettem} ${Http_status_codes[1]}
echo -e '\E[33m' "The number of http status[300+]:" ${resettem} ${Http_status_codes[2]}
echo -e '\E[33m' "The number of http status[400+]:" ${resettem} ${Http_status_codes[3]}
echo -e '\E[33m' "The number of http status[500+]:" ${resettem} ${Http_status_codes[4]}
echo -e '\E[33m' "All request numbers:" ${resettem} ${Http_status_codes[5]}
}
Check_http_code()
{
Http_codes=(`cat $Logfile_path|grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}"|awk -v total=0 -F '[ ]+' '{
if($2!="")
{code[$2]++;total++}
else
{exit}
}END{
print code[404]?code[404]:0,code[403]?code[403]:0,total
}'
`)
echo -e '\E[33m' "The number of http status[404]:" ${resettem} ${Http_codes[0]}
echo -e '\E[33m' "The number of http status[403]:" ${resettem} ${Http_codes[1]}
echo -e '\E[33m' "All request numbers:" ${resettem} ${Http_codes[2]}
}
Check_http_status
Check_http_code