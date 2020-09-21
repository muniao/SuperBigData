#!/bin/bash

# This script is use to automatically configure Conoha LAN IP
# reference https://www.conoha.jp/conoben/archives/10174

IPADDR=$1

if [ "$IPADDR" == "" ]; then
  echo -e "\033[33merror: ip address is blank\033[0m"
  echo -e "\033[32muse ./init_private_neiwork.sh IPADDRESS NETMASK [ETH_BUMBER] [MAC_ADDRESS]\033[0m"
  exit 1
fi

NETMASK=$2

if [ "$NETMASK" == "" ]; then
  echo -e "\033[33merror: netmask is blank\033[0m"
  echo -e "\033[32muse ./init_private_neiwork.sh IPADDRESS NETMASK [ETH_BUMBER] [MAC_ADDRESS]\033[0m"
  exit 1
fi

ETH_BUMBER=$3

if [ "$ETH_BUMBER" == "" ]; then
  ETH_BUMBER="eth1"
fi

MAC_ADDRESS=$4

if [ "$MAC_ADDRESS" == "" ]; then
  yum update -y >> /dev/null 2>&1 && yum upgrade -y >> /dev/null 2>&1 && yum install net-tools >> /dev/null 2>&1
  MAC_ADDRESS=`ifconfig "$ETH_BUMBER" | grep ether | awk -F" " '{print $2}'`
  if [ "$MAC_ADDRESS" == "" ]; then
    echo -e "\033[33mget MAC_ADDRESS"
    echo -e "\033[33mget MAC_ADDRESS failed! please input MAC_ADDRESS!"
    exit 1
  fi
fi

echo -e "\033[32mupdate /etc/sysconfig/network-scripts/ifcfg-$ETH_BUMBER...\033[0m"
echo ""

# setting network
tee /etc/sysconfig/network-scripts/ifcfg-$ETH_BUMBER <<EOF
DEVICE=$ETH_BUMBER
TYPE=Ethernet
HWADDR=$MAC_ADDRESS
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=$IPADDR
NETMASK=$NETMASK
EOF

echo ""
echo -e "\033[32mupdate  /etc/iproute2/rt_tables...\033[0m"
echo ""

tee /etc/iproute2/rt_tables <<EOF
201     gate1
EOF

echo ""
echo -e "\033[32mupdate  /etc/sysconfig/network-scripts/rule-$ETH_BUMBER...\033[0m"
echo ""

tee /etc/sysconfig/network-scripts/rule-$ETH_BUMBER <<EOF
from $IPADDR table gate1
EOF

echo ""
echo -e "\033[32mupdate  /etc/sysconfig/network-scripts/route-$ETH_BUMBER...\033[0m"
echo ""

tee /etc/sysconfig/network-scripts/route-$ETH_BUMBER <<EOF
default via $IPADDR table gate1
EOF

echo ""
echo -e "\033[32mrestart network...\033[0m"

systemctl restart network
