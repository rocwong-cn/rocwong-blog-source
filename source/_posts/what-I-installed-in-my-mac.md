---
title: 我的 Mac 上都装了啥
tags:
  - 好物推荐
categories:
  - 装机必备
date: 2020-07-11 10:09:21
---

仍记得多年前我买了自己第一台 Mac 的时候，第一时间就是去搜索「如何高效的使用 Mac」「Mac 上好用的 APP 推荐」类似这样的关键字，希望可以借助别人的一些经验来完善自己的 Mac ，这中间自己也尝试了很多，下面把我觉得好用的一些软件列一下。

 <!-- more -->


## 编辑器和Terminal

编辑器已经从webstorm切到了vscode，vscode真的好用，所使用的的扩展有：

* Bracket Pari Colorizer 2
* BridleNSIS
* Debugger for Chrome
* ESLint
* GitLens
* HTML Snippets
* LeetCode
* Material Icon Theme
* npm
* open in browser
* output colorizer
* react native tools
* TODO Highlight
* vetur

终端使用的是[iTerm2](https://www.iterm2.com/) 配合 oh my zsh!

参考：[iTerm2 + Oh My Zsh 打造舒适终端体验](https://segmentfault.com/a/1190000014992947)

## 开发辅助

* [postman](https://www.postman.com/) 接口联调
* [Charles](https://www.charlesproxy.com/) 抓包用，支持 https
* Google Chrome + Firefox + Safari，浏览器，调试用。Chrome启用的扩展有：
    - Redux DevTools 2.17.0
    - Allow-Control-Allow-Origin: * 1.0.3
    - Axure RP Extension for Chrome 0.6.3
    - Chrome Better History 3.50
    - EditThisCookie 1.5.0
    - FeHelper(前端助手) 2020.5.2810
    - Octotree 5.2.1
    - Placeholdifier 0.2.0
    - React Developer Tools 4.7.0 (5/18/2020)
    - Tag Assistant (by Google) 20.65.0
    - Vue.js devtools 5.3.3
    - 保护眼睛 2.1.3

## 一些好用的 git alias
```
  st = status
  co = checkout
  cam = commit -a -m
  p = push
  pl = pull
  cob = checkout -b
  del = restore --staged
  pure = pull --rebase
  confall = config --global --list
```

## 画图

* [OmniGraffle](https://www.omnigroup.com/omnigraffle) 用来画架构图
* [xmind](https://www.xmind.cn/) 思维导图

## 文字处理

* [Typora](https://typora.io/) markdown 高颜值简洁、支持多文件
* [有道云笔记](http://note.youdao.com/download.html?auto=1#mac) 云端笔记同步

## 截图

* [Xnip](https://zh.xnipapp.com/) 可以进行标注，取色
* [LICEcap](https://www.cockos.com/licecap/) 录屏、gif图
* [截图](https://jietu.qq.com/) 顾名思义，腾讯出的截图工具

## 效率

* [Alfred](https://www.alfredapp.com/) + [Powerpack](https://www.alfredapp.com/powerpack/) 应用启动、粘贴板管理、Workflow、Snippets 管理等
* [Thor](https://github.com/gbammc/Thor) 一键直达应用
* [magnet](https://magnet.crowdcafe.com/) 窗口布局工具

## 其他

* [f.lux](https://justgetflux.com) 调节显示器色温，护眼，尤其是早上起来屏幕实在是刺眼
* [网易云音乐](https://music.163.com/) 不过最近歌单里被下架的歌有点多

## 通过 npm 安装

- [projj](https://github.com/popomore/projj) github/gitlab 项目管理
- [serve](https://github.com/zeit/serve) 本地静态服务器
- [fkill](https://github.com/sindresorhus/fkill) 比 kill 好用的进程 killer
- [qrcode-terminal](https://github.com/gtanner/qrcode-terminal) 二维码生成
- [fy](https://github.com/afc163/fanyi) 英汉互译

## 翻墙

* 服务商使用的是 [shadowsocks](https://portal.shadowsocks.nz/aff.php?aff=38994)，还算比较稳定，比较好的节点偶尔可以低至 30ms 的延迟。
* Mac 客户端使用的是TrojanX，手机方面目前没有翻墙的需求。

#### 免费

- [refiddle](http://refiddle.com/) + [regex101](https://regex101.com/)，调正则表达式
- [30 seconds of code](https://30secondsofcode.org/)，代码片段
- [astexplorer](https://astexplorer.net/)，调 ast
- [globtester](http://www.globtester.com/)，调 glob
- [ghub.io](http://ghub.io/)，redirect to an npm package's repository page
- [unpkg](https://unpkg.com/)，npm 包的 cdn 服务，可以查看 npm 包发布后的内容
- [sketchboard](https://sketchboard.me/) + [draw.io](https://www.draw.io/) + [MindMeister](https://www.mindmeister.com/) + [Whimsical](https://whimsical.com/)，在线画流程图
- [HackMD](https://hackmd.io/recent)，在线笔记，有 PPT 展示功能
- [Slides](https://slides.com/)，PPT 制作
- [CodeSandbox](https://codesandbox.io/) + [glitch](https://glitch.com/) + [repl.it](https://repl.it/)，在线代码编辑，前者支持 sandbox container，可以跑 npm scripts
- [node.green](https://node.green/)，查询 NodeJS 的 ES2018 特性支持情况
- [Can I use](https://caniuse.com/)，查询浏览器的特性支持情况
- [carbon](https://carbon.now.sh/)，根据源码生成图片
- [Tell me when it closes](https://tellmewhenitcloses.com)，github issue 关闭时发送邮件通知
- [Package Diff](https://diff.intrinsic.com/)，比较 npm 包两个版本直接的区别
- [Firefox Send](https://send.firefox.com/) + [ffsend](https://github.com/timvisee/ffsend)，文件分享服务
- [Cloud Convert](https://cloudconvert.com/)，支持 218 种格式相互转换
- [SVGR](https://www.smooth-code.com/open-source/svgr/playground/)，SVG 转 React 组件
- （beta）[Webpack config tool](https://webpack.jakoblind.no/)，webpack 配置工具
- [代码在线运行工具](https://tool.lu/coderunner/)
- [icomoon](https://icomoon.io/app/#/select) svg转font
- [css triggers](https://csstriggers.com/) css样式详解及在各浏览器引擎下的支持情况


如果你有什么好用的软件或者黑科技也欢迎在下方留言告诉我~