---
title: centos下的端口操作
tags:
  - centos
categories:
  - 服务器操作
date: 2019-03-04 10:16:08
---

## 1、Centos查看端口占用

比如查看80端口占用情况使用如下命令：

``` bash
lsof -i tcp:80
```
<!-- more -->
## 2、列出所有端口
查看当前所有tcp端口：
```bash
netstat -ntlp
```

查看某一端口的连接客户端IP 比如3306端口：
``` bash
netstat -anp |grep 3306
```

## 3、开启端口（以80端口为例）

### 3.1、方法一
写入修改
``` bash
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
```
保存修改
``` bash
/etc/init.d/iptables save
```
重启防火墙，修改生效
``` bash
service iptables restart
```
### 3.2、方法二：
打开配置文件加入如下语句:
``` bash
vi /etc/sysconfig/iptables
```
添加
``` bash
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
```
重启防火墙，修改生效
``` bash
service iptables restart
```
## 4、关闭端口
### 4.1、方法一：
写入修改
``` bash
/sbin/iptables -I INPUT -p tcp --dport 80 -j DROP
```
保存修改
``` bash
/etc/init.d/iptables save
```
重启防火墙，修改生效
``` bash
service iptables restart
```
### 4.2、方法二：
打开配置文件
``` bash
vi /etc/sysconfig/iptables
```
添加
``` bash
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j DROP
```
重启防火墙，修改完成
``` bash
service iptables restart
```
## 5、查看端口状态
``` bash
/etc/init.d/iptables status
```