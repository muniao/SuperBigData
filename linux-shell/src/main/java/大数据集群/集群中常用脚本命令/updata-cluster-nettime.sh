#!/bin/bash

for i in {1..4}
do
 ssh test0$i "ntpdate cn.pool.ntp.org;date"
done

