---
title: 使用Jenkins持续集成并部署GitHub项目
date: 2019-03-02 13:14:28
tags: Jenkins
categories: 项目部署
---
> 本文档旨在使用Jenkins来持续集成并一键部署我们使用hexo博客系统建造的个人博客。
> 所以开始之前，我假设你已经具有了一个本地创建完成，且deploy到GitHub上的hexo博客项目。
> 注意，是deploy后的静态资源，因为我们最终挂载到Nginx下的也是hexo generate后的静态资源。

<!-- more -->

## 1.安装jenkins

### 环境：`CentOS 7.0`

### 安装方式：

```bash
$ yum install yum-fastestmirror -y  #安装自动选择最快源的插件
#添加Jenkins源:
$ sudo wget -O /etc/yum.repos.d/jenkins.repo http://jenkins-ci.org/redhat/jenkins.repo
$ sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
$ yum install jenkins               #安装jenkins
```

### 启动方式：

`$ sudo service jenkins start`

### 访问方式：

浏览器输入`http://your server ip:8080/`

### 更改配置（如端口）方式：

```bash
$ vim /etc/sysconfig/jenkins
$ sudo service jenkins restart
```

## 2.jenkins基础配置

### Unlock

经过上面的配置，你可以访问你的Jenkins了，在浏览器中输入：`http://your server ip:8080/`，效果如下：

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/1.png)

按照提示我们执行`cat /var/lib/jenkins/secrets/initialAdminPassword`得到`Administrator password`，输入后点击Continue，如下：

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/2.png)

选择`install suggested plugins`，等待安装完毕，如果有安装失败的可以跳过，之后可以手动根据需求安装。

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/3.png)

### 设置初始账户和密码

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/4.png)

设置完成后进入界面：

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/5.png)

## 3.github配置

### sercret text

注：此处需要一个对项目有写权限的账户

> 进入github --> setting --> Personal Access Token --> Generate new token

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/6.png)

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/7.png)

自己先保存此`token`，如果丢失，之后再也无法找到这个`token`。

### GitHub webhooks 设置

> 进入GitHub上指定的项目 --> setting --> WebHooks&Services --> add webhook --> 输入刚刚部署jenkins的服务器的IP

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/8.png)

## 4.jenkins的github配置

### 安装GitHub Plugin

> 系统管理-->插件管理-->可选插件

直接安装Github Plugin, jenkins会自动帮你解决其他插件的依赖，直接安装该插件Jenkins会自动帮你安装plain-credentials 、[Git](http://lib.csdn.net/base/git) 、 credentials 、 github-api

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/9.png)

### 配置GitHub Plugin

> 系统管理 --> 系统设置 --> GitHub --> Add GitHub Sever

如下图所示

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/10.png)

API URL 输入 `https://api.github.com`，Credentials点击Add添加，Kind选择Secret Text,具体如下图所示。

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/11.png)

设置完成后，点击`TestConnection`,提示`Credentials
 verified for user UUserName, rate limit: xxx`,则表明有效。

## 5.创建一个freestyle任务

\- General 设置
填写GitHub project URL, 也就是你的项目主页
eg. `https://github.com/your_name/your_repo_name`

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/Jenkins-ghrepo-info.png)

\- 配置源码管理

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/Jenkins-source-manage.png)

1. 填写项目的git地址, eg. `https://github.com/your_name/your_repo_name.git`
2. 添加github用户和密码
3. 选择githubweb源码库浏览器，并填上你的项目URL，这样每次构建都会生成对应的changes，可直接链到github上看变更详情

\- 构建触发器，构建环境

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/12.png)

## 6.实现自动化部署

自动化部署可能是我们最需要的功能了，公司就一台服务器，我们可以使用人工部署的方式，但是如果公司有100台服务器呢，人工部署就有些吃力了，而且一旦线上出了问题，回滚也很麻烦。所以这一节实现一下自动部署的功能。

1. 首先，先在Jenkins上装一个插件Publish Over SSH，我们将通过这个工具实现服务器部署功能。
2. 在要部署代码的服务器上创建一个文件夹用于接收Jenkins传过来的代码，由于我的个人博客是直接挂载在Nginx下的，所以我在我的Nginx路径下新建了一个`html_temp`目录。
3. Jenkins想要往服务器上部署代码必须登录服务器才可以，这里有两种登录验证方式，一种是ssh验证，一种是密码验证，就像你自己登录你的服务器，你可以使用ssh免密登录，也可以每次输密码登录，`系统管理-系统设置`里找到Publish over SSH这一项。
重点参数说明：

```js
Passphrase：密码（key的密码，没设置就是空）
Path to key：key文件（私钥）的路径
Key：将私钥复制到这个框中(path to key和key写一个即可)

SSH Servers的配置：
SSH Server Name：标识的名字（随便你取什么）
Hostname：需要连接ssh的主机名或ip地址（建议ip）
Username：用户名
Remote Directory：远程目录

高级配置：
Use password authentication, or use a different key：勾选这个可以使用密码登录，不想配ssh的可以用这个先试试
Passphrase / Password：密码登录模式的密码
Port：端口（默认22）
Timeout (ms)：超时时间（毫秒）默认300000
```

效果图：
![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/Jenkins-overssh.png)

配置完成后，点击Test Configuration测试一下是否可以连接上，如果成功会返回success，失败会返回报错信息，根据报错信息改正即可。

1. 接下来进入我们创建的任务，点击**构建**，增加一些脚本代码，意思是将我hexo博客生成的静态资源打包成一个文件，因为我们要传输。

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/Jenkins-building.png)

5. 点击**构建后操作**，增加构建后操作步骤，选择send build artificial over SSH， 参数说明：

``` js
Name:选择一个你配好的ssh服务器
Source files ：写你要传输的文件路径
Remove prefix ：要去掉的前缀，不写远程服务器的目录结构将和Source files写的一致
Remote directory ：写你要部署在远程服务器的那个目录地址下，不写就是SSH Servers配置里默认远程目录
Exec command ：传输完了要执行的命令，我这里执行了解压缩和解压缩完成后删除压缩包2个命令
```
![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/jenkins/Jenkins-after-build.png)

6. 现在在我们本地的`hexo`博客系统里面随便修改点东西，然后执行以下：

``` shell
hexo g
hexo d
```
向GitHub repo提交一次`push`操作后，就会自动触发自动构建、远程部署的钩子，我们的博客系统就会自动集成新的内容了。


## 7.参考：

> [Jenkins+Github持续集成](http://www.jianshu.com/p/b2ed4d23a3a9)
> [Jenkins入门总结](http://www.cnblogs.com/itech/archive/2011/11/23/2260009.html)
> [Jenkins打造强大的前端自动化工作流](https://juejin.im/post/5ad1980e6fb9a028c42ea1be)