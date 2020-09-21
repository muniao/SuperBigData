#!/bin/bash
for i in {2..4}
do scp spark-2.3.0-bin-hadoop2.7.tgz test0$i:~;
done
