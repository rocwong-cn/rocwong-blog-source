---
title: 解决 brew update 时间太久的问题
tags:
  - Homebrew
categories:
  - 装机必备
date: 2020-08-03 21:16:37
---

你是否还在因为使用 `brew install` 时卡在 `update` 阶段而捶胸顿足，甚至一度想放弃`brew`，那么今天你的救星来啦~

 <!-- more -->

## 问题

使用 `brew install` 时会触发 `brew update`，而update阶段主要是进行`homebrew-cask` 和 `homebrew-core` 及一些其他相关依赖的更新，这些依赖都托管在GitHub，由于国内网络访问GitHub本身就比较慢，做大文件下载的速度可想而知会更慢。

## 初步分析

使用brew update --verbose观察update过程：

```bash
brew update --verbose
Checking if we need to fetch /usr/local/Homebrew...
Checking if we need to fetch /usr/local/Homebrew/Library/Taps/caskroom/homebrew-fonts...
Fetching /usr/local/Homebrew...
Checking if we need to fetch /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask...
Checking if we need to fetch /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core...
Fetching /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask...
Fetching /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core...
remote: Enumerating objects: 337, done.
remote: Counting objects: 100% (337/337), done.
remote: Compressing objects: 100% (88/88), done.
remote: Total 298 (delta 221), reused 287 (delta 210), pack-reused 0
Receiving objects: 100% (298/298), 50.91 KiB | 39.00 KiB/s, done.
Resolving deltas: 100% (221/221), completed with 39 local objects.
From https://github.com/Homebrew/homebrew-core
   65a45a9..583b7f1  master     -> origin/master
remote: Enumerating objects: 179429, done.
remote: Counting objects: 100% (179429/179429), done.
remote: Compressing objects: 100% (56607/56607), done.
Receiving objects:   4% (7628/177189), 1.48 MiB | 8.00 KiB/s
```

可以发现在从 GitHub fetch 资源时是最罪恶根源。

## 解决方案两步走

### step one. 更换Homebrew源

目前国内比较好用的brew源有很多，比较推荐使用*清华大学开源软件镜像站*的，以下是详细配置：

```bash
# brew 程序本身，Homebrew/Linuxbrew 相同
git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

# 以下针对 mac OS 系统上的 Homebrew
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git

# 以下这两个命令行可以不执行，不影响最终结果
git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git
git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-drivers.git

# 以下针对 Linux 系统上的 Linuxbrew
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/linuxbrew-core.git

```

配置完成后，可以到对应的目录下查看`git remote`配置，如：

```bash
cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
git remote -v
```

看到显示为如下的结果说明已经配置成功：

```bash
origin	https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git (fetch)
origin	https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git (push)
```

### step two. 更换 Homebrew-bottles 镜像（影响软件下载速度）

临时替换

``` bash
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
```

永久替换

```bash
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.bash_profile
source ~/.bash_profile
```

至此，已经完成了brew源的切换，可以运行 `brew update` 测试是否正常。

参考链接：
- [Homebrew/Linuxbrew 镜像使用帮助 - 清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)
- [Homebrew-bottles 镜像使用帮助 - 清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew-bottles/)

## 异常情况

### homebrew-versions 相关报错

如果在执行`brew update`时出现如下报错：

```bash
fatal: could not read Username for 'https://github.com': terminal prompts disabled
Error: Fetching /usr/local/Homebrew/Library/Taps/homebrew/homebrew-versions failed!
```

说明你的brew版本太老旧了，在新版中`homebrew-versions`已经被移除了，可以执行如下命令来移除它：

```bash
brew untap homebrew/versions
```

参考链接：[Error running brew update](https://discourse.brew.sh/t/error-running-brew-update/7754)

### homebrew-cask-fonts 相关报错

当执行上述的`git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git` 命令时，如出现下方错误，则可以忽略错误，并不执行该命令，不影响最终体验。

```bash
fatal: Cannot change to '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask-fonts': No such file or directory
```
