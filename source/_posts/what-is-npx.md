---
title: npx是什么？它和npm什么关系？
tags:
  - 构建工具
categories:
  - 项目部署
date: 2019-09-26 18:57:25
---
`npx`是一个工具，`npm` v5.2.0引入的一条命令（npx），一个`npm`包执行器，旨在提高从`npm`注册表使用软件包的体验 ，`npm`使得它非常容易地安装和管理托管在注册表上的依赖项，`npx`使得使用CLI工具和其他托管在注册表。它大大简化了一些事情。

<!-- more -->

就像`npm`极大地提升了我们安装和管理包依赖的体验，在`npm`的基础之上，`npx`让`npm`包中的命令行工具和其他可执行文件在使用上变得更加简单。它极大地简化了我们之前使用纯粹的`npm`时所需要的大量步骤。

那么下面更详细的举例让你更加理解：使用`create-react-app`创建一个`react`项目。

老方法：

```
npm install -g create-react-app
create-react-app my-app
```

npx方式：

```
npx create-react-app my-app
```

这条命令会临时安装 `create-react-app` 包，命令完成后`create-react-app` 会删掉，不会出现在 `global`中。下次再执行，还是会重新临时安装。

`npx` 会帮你执行依赖包里的二进制文件。

举例来说，之前我们可能会写这样的命令：

```
npm i -D webpack
./node_modules/.bin/webpack -v
```
如果你对 `bash` 比较熟，可能会写成这样：

```
npm i -D webpack`npm bin`/webpack -v
```

有了 `npx`，你只需要这样：

```
npm i -D webpack
npx webpack -v
```

也就是说 `npx` 会自动查找当前依赖包中的可执行文件，如果找不到，就会去 `PATH` 里找。如果依然找不到，就会帮你安装！

`npx` 甚至支持运行远程仓库的可执行文件：

```
npx github:piuccio/cowsay hello
```

再比如 `npx http-server` 可以一句话帮你开启一个静态服务器！（第一次运行会稍微慢一些）

```
npx http-server
```

指定node版本来运行`npm scripts`：

```
npx -p node@8 npm run build
```

主要特点：
* 临时安装可执行依赖包，不用全局安装，不用担心长期的污染。
* 可以执行依赖包中的命令，安装完成自动运行。
* 自动加载node_modules中依赖包，不用指定$PATH。
* 可以指定node版本、命令的版本，解决了不同项目使用不同版本的命令的问题。
