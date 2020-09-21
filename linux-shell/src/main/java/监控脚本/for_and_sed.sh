#!/bin/bash  
#重复造数据，并用sed重新编辑cp的文件

#替换：s命令 sed  ‘s/abc/def/g’ file

for((i=2;i<=3;i++));  
do   
cp 1 $i;  
sed -i  "s/test/test_changed_$i/g" ./$i
cat $i
done  
