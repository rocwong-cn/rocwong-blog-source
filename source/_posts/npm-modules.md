---
title: 一些能提升生产力的轮子收集
tags:
  - 好物推荐
categories:
  - 我爱折腾
date: 2020-10-24 17:33:56
---
我们在工作或者日常的个人项目开发过程中，常常需要一些轮子来辅助我们，提高生产力。但是，很多时候会出现”书到用时方恨少“的局面，很多好的第三方库我们若平时不记录，不积累，到开发的时候，我们就不得不找一些折中方案或者无法更加完美的实现。
 <!-- more -->
以下是我收集的一些轮子，记录再次方便以后应用。

## [inquirer](https://www.npmjs.com/package/inquirer)

> 常见的交互式命令行用户界面的集合

### 安装

```bash
yarn add inquirer
```

### 使用

```js
var inquirer = require('inquirer');
inquirer
  .prompt([
    /* Pass your questions in here */
  ])
  .then(answers => {
    // Use user feedback for... whatever!!
  })
  .catch(error => {
    if(error.isTtyError) {
      // Prompt couldn't be rendered in the current environment
    } else {
      // Something else when wrong
    }
  });
  ```

### 预览

![demo](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/default/inquirer.gif)

## [commander](https://www.npmjs.com/package/commander)

> 完整的 node.js 命令行解决方案，灵感来自 Ruby 的 commander。可以实现自定义CLI。

### 安装

```bash
yarn add commander
```

### 使用

为简化使用，`Commander` 提供了一个全局对象。本文档的示例代码均按此方法使用：

```js
const { program } = require('commander');
program.version('0.0.1');
```

如果程序较为复杂，用户需要以多种方式来使用 `Commander`，如单元测试等。创建本地 `Command` 对象是一种更好的方式：

```js
const { Command } = require('commander');
const program = new Command();
program.version('0.0.1');
```

具体信息请前往其主页进行查看。

## [nprogress](https://github.com/rstacruz/nprogress)

> 适用于Ajax'y应用程序的超薄进度条。受到Google，YouTube和Medium的启发。

### 安装

可以将 `nprogress.js` 和 `nprogress.css` 直接添加到你的项目中。

```html
<script src='nprogress.js'></script>
<link rel='stylesheet' href='nprogress.css'/>
```

也可以通过`npm`安装

```bash
$ npm install --save nprogress
```

或者直接使用 CDN 的方式

```
https://unpkg.com/nprogress@0.2.0/nprogress.js
https://unpkg.com/nprogress@0.2.0/nprogress.css
```

### 使用

一个比较简单的使用方式：

```js
NProgress.start();
NProgress.done();
```

## [Luckysheet](https://github.com/mengshukeji/Luckysheet/blob/master/README-zh.md)

> 一款纯前端类似excel的在线表格，功能强大、配置简单、完全开源。

![demo](https://github.com/mengshukeji/Luckysheet/raw/master/docs/.vuepress/public/img/LuckysheetDemo.gif)

## [zxcvbn](https://www.npmjs.com/package/zxcvbn)

> 密码强度估算器。（作者取这个名字估计是调侃一下那些密码按照键盘顺序输入的人吧，哈哈）。zxvbn检测并支持CommonJS（node，browserify）和AMD（RequireJS）。如果没有这些，它将向全局命名空间添加一个函数zxvbn（）。


### 安装

```bash
cd /path/to/project/root
bower install zxcvbn
```

并且将以下脚本添加到你的 `index.html` 中:

```html
<script src="bower_components/zxcvbn/dist/zxcvbn.js">
</script> 
```

要确保加载正确，请在浏览器中打开并在控制台中键入zxvbn（'Tr0ub4dour&amp;3'）。

## [utility](https://www.npmjs.com/package/utility)

> 一些有用的工具方法汇总

### 安装

```bash
$ npm install utility
```

### 使用

```js
const utils = require('utility');
```

或者

```js
import * as utility from 'utility';
```

目前包含的[工具类参考](https://github.com/node-modules/utility/tree/master/lib)

## [projj](https://github.com/popomore/projj)

> 更方便的管理你的本地代码仓库，Git 用户名，一键切换。

### 安装

```bash
$ yarn global add projj
```

### 使用

```bash
projj add XXXX
projj find XXXX
```

具体使用方法请访问[云谦的这个视频](https://www.bilibili.com/video/BV1Bt411q7VV)查看。

好了，今天的分享先到这里，以后有其他好的轮子，我会持续更新这篇文章的。也欢迎你在评论区告诉我，你有什么好玩儿的轮子~
