#!/bin/bash

shellName=`ps | grep $$ | awk '{print $4}'`

if [ "$shellName" == "zsh" ]; then
  read "cerpath?请输入证书存放目录: "
  read "domains?请输入域名(多个以空格分割): "
  read "reloadcmd?请输入重载命令(非必选): "
else
  read -p "请输入证书存放目录: " cerpath
  read -p "请输入域名(多个以空格分割): " domains
  read -p "请输入重载命令(非必选): " reloadcmd
fi

if [ "$cerpath" == "" ] ||  [ "$domains" == "" ]; then
  echo -e "\033[31merror: cerpath or domains is blank!"
  exit 1
else
  mkdir -p $cerpath
fi

allDomian=($domains)

for domainName in ${allDomian[@]}; do
  installcert+=" -d $domainName"
done

~/.acme.sh/acme.sh  --installcert $installcert \
                    --keypath $cerpath/${allDomian[0]}.key \
                    --capath $cerpath/ca.cer \
                    --fullchainpath $cerpath/${allDomian[0]}.cer \
                    --reloadcmd "$reloadcmd"
