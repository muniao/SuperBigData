# 集群分发脚本xsync

<nav>
    <a href="#一、scp（secure copy）安全拷贝">一、scp（secure copy）安全拷贝</a><br/>
<a href="#二、rsync 远程同步工具">二、rsync 远程同步工具</a><br/>
<a href="#三、xsync集群分发脚本">三、xsync集群分发脚本</a><br/>
</nav>




## 一、scp（secure copy）安全拷贝

1. scp定义：

scp可以实现服务器与服务器之间的数据拷贝。（from server1 to server2）

2. 基本语法

```
scp   -r         $pdir/$fname        $user@hadoop$host:$pdir/$fname

命令  递归     要拷贝的文件路径/名称      目的用户@主机:目的路径/名称
```

3. 案例实操

（a）在hadoop101上，将hadoop101中/opt/module目录下的软件拷贝到hadoop102上。

```shell
[atguigu@hadoop101 /]$ scp -r /opt/module  root@hadoop102:/opt/module
```

（b）在hadoop103上，将hadoop101服务器上的/opt/module目录下的软件拷贝到hadoop103上。

```shell
[atguigu@hadoop103 opt]$sudo scp -r atguigu@hadoop101:/opt/module root@hadoop103:/opt/module
```

注意：拷贝过来的/opt/module目录，别忘了在hadoop102、hadoop103上修改所有文件的，所有者和所有者组。sudo chown atguigu:atguigu -R /opt/module

(c）将hadoop101中/etc/profile文件拷贝到hadoop102的/etc/profile上

```shell
[atguigu@hadoop101 ~]$ sudo scp /etc/profile root@hadoop102:/etc/profile
```

注意：拷贝过来的配置文件别忘了source一下/etc/profile

## 二、rsync 远程同步工具

rsync主要用于备份和镜像。具有速度快、避免复制相同内容和支持符号链接的优点。

rsync和scp区别：用rsync做文件的复制要比scp的速度快，rsync只对差异文件做更新。scp是把所有文件都复制过去。

​    （1）基本语法

rsync   -av    $pdir/$fname        $user@hadoop$host:$pdir/$fname

命令  选项参数  要拷贝的文件路径/名称  目的用户@主机:目的路径/名称

​     选项参数说明

| 选项 | 功能         |
| ---- | ------------ |
| -a   | 归档拷贝     |
| -v   | 显示复制过程 |

（2）案例实操

​        （a）把hadoop101机器上的/opt/software目录同步到hadoop102服务器的root用户下的/opt/目录

```shell
[atguigu@hadoop101 opt]$ rsync -av /opt/software/ hadoop102:/opt/software
```



## 三、xsync集群分发脚本

**1. 需求：循环复制文件到所有节点的相同目录下**

**2. 需求分析：**

(1)rsync命令原始拷贝：

```shell
rsync  -av     /opt/module  		 root@hadoop103:/opt/
```

​    （b）期望脚本：

xsync要同步的文件名称

​     （c）说明：在/home/atguigu/bin这个目录下存放的脚本，atguigu用户可以在系统任何地方直接执行。

**3. 脚本实现**

（a）在/home/atguigu目录下创建bin目录，并在bin目录下创建xsync文件

```shell
[atguigu@hadoop101 hadoop] cd /home/atguigu
[atguigu@hadoop101 ~] mkdir  bin 
[atguigu@hadoop101 bin] touch xsync
[atguigu@hadoop101 bin] vim xsync
```

在该文件中编写如下代码

```shell
#!/bin/bash
#1. 判断参数个数
if [ $# -lt 1 ]
then
  echo Not Enough Arguement!
  exit;
fi
#2. 遍历集群所有机器
for host in hadoop102 hadoop103 hadoop104
do
  echo ====================  $host  ====================
  #3. 遍历所有目录，挨个发送
  for file in $@
  do
    #4 判断文件是否存在
    if [ -e $file ]
    then
      #5. 获取父目录
      pdir=$(cd -P $(dirname $file); pwd)
      #6. 获取当前文件的名称
      fname=$(basename $file)
      ssh $host "mkdir -p $pdir"
      rsync -av $pdir/$fname $host:$pdir
    else
      echo $file does not exists!
    fi
  done
done
```

（b）修改脚本 xsync 具有执行权限

```shell
chmod +x xsync
```

（c）测试脚本

```shell
touch /opt/module/cc.log
xsync /opt/module/cc.log
```

