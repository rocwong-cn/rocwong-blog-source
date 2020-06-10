---
title: 深入理解浏览器系列之进程与线程之间的区别
tags:
  - 进程与线程
categories:
  - 浏览器
date: 2020-06-09 11:15:21
---

![banner](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/browser/process-thread.png)

<!-- more -->

## 什么是进程？什么是线程？

### 进程的定义

进程是执行中的一段程序，即一旦程序被载入到内存中并准备执行，它就是一个进程。进程是表示资源分配的基本概念，又是调度运行的基本单位，是系统中的并发执行的单位。

### 线程的定义

单个进程中执行的每个任务就是一个线程。线程是进程中执行运算的最小单位。
一个线程只能属于一个进程，但是一个进程可以拥有多个线程。多线程处理就是允许一个进程中在同一时刻执行多个任务。

可以结合下图来理解二者之间的关系：

![图说进程和线程](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/browser/cartoon-process-thread.jpg)

## 进程 VS 线程

首先，我们知道浏览器在处理任务时，使用并行处理相较串行处理而言可以大大提升性能。对应到线程里面来讲，也就是单线程就是串行，多线程就可以实现并行。线程是依附于进程的，而进程中使用多线程并行处理就能提升运算效率。

![单线程和多线程](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/browser/single-vs-many-threads.png)

总结来说，进程和线程的关系有以下4个特点：

* 进程中的任意一个线程执行出错，都会导致整个进程的崩溃；
* 线程之间共享进程中的数据；
* 当一个进程关闭后，操作系统会回收进程所占用的内存；
* 进程之间的内容相互隔离，如果进程之间需要通信则需使用IPC。

## 单进程浏览器时代

> 单进程浏览器是指浏览器的所有功能模块都是运行在同一个进程里。这些模块包含了网络、插件、js运行环境、渲染引擎和页面等。

单进程浏览器的弊端：

* 不稳定；

若插件崩溃或者内存泄露时，容易阻塞浏览器主进程造成浏览器崩溃；

* 不流畅；

若js运行环境中有特别耗时，如执行了一个无限循环脚本，它会独占整个县城，导致真个浏览器失去响应、卡顿等。

* 不安全；

插件模块在主进程中，可以获取到操作系统的任意资源，这就给了恶意插件入侵电脑的可趁之机。

## 多进程浏览器时代

### 早期的多进程架构

![早期的多进程架构](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/browser/early-many-process.png)

上图是2008年Chrome发布时的进程架构。从图中可以看出，Chrome的页面是运行在单独的渲染进程中的，同时页面里的插件也是运行的单独的插件进程中的，而进程之间的通信依赖IPC。

多进程浏览器很好的解决了上述的三个问题：

1. 由于进程是相互隔离的，所以某个进程的崩溃不影响浏览器和其他页面。
2. js也是运行在渲染进程中的，所以即使JS阻塞了渲染进程，也不影响其他页面。
3. 采用多进程架构的额外好处是可以使用**安全沙箱**，你可以把沙箱看成是操作系统给进程上了一把锁，沙箱里面的程序可以运行，但是不能在你的硬盘上写入任何数据，也不能在敏感位置读取任何数据，例如你的文档和桌面。Chrome 把插件进程和渲染进程锁在沙箱里面，这样即使在渲染进程或者插件进程里面执行了恶意程序，恶意程序也无法突破沙箱去获取系统权限。

### 目前多进程架构

![目前多进程架构](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/browser/latest-many-process.png)

从图中可以看出，最新的 Chrome 浏览器包括：1 个浏览器（Browser）主进程、1 个 GPU 进程、1 个网络（NetWork）进程、多个渲染进程和多个插件进程。

* **浏览器进程**。主要负责界面显示、用户交互、子进程管理，同时提供存储等功能。
* **渲染进程**。核心任务是将 HTML、CSS 和 JavaScript 转换为用户可以与之交互的网页，排版引擎 Blink 和 JavaScript 引擎 V8 都是运行在该进程中，默认情况下，Chrome 会为每个 Tab 标签创建一个渲染进程。出于安全考虑，渲染进程都是运行在沙箱模式下。
* **GPU 进程**。其实，Chrome 刚开始发布的时候是没有 GPU 进程的。而 GPU 的使用初衷是为了实现 3D CSS 的效果，只是随后网页、Chrome 的 UI 界面都选择采用 GPU 来绘制，这使得 GPU 成为浏览器普遍的需求。最后，Chrome 在其多进程架构上也引入了 GPU 进程。
* **网络进程**。主要负责页面的网络资源加载，之前是作为一个模块运行在浏览器进程里面的，直至最近才独立出来，成为一个单独的进程。
* **插件进程**。主要是负责插件的运行，因插件易崩溃，所以需要通过插件进程来隔离，以保证插件进程崩溃不会对浏览器和页面造成影响。

多进程模型的弊端：

* 更高的资源占用；
* 更复杂的体系结构；

## 未来面向服务的架构

为了解决这些问题，在 2016 年，Chrome 官方团队使用“面向服务的架构”（Services Oriented Architecture，简称 SOA）的思想设计了新的 Chrome 架构。也就是说 Chrome 整体架构会朝向现代操作系统所采用的“面向服务的架构” 方向发展，原来的各种模块会被重构成独立的服务（Service），每个服务（Service）都可以在独立的进程中运行，访问服务（Service）必须使用定义好的接口，通过 IPC 来通信，从而构建一个更内聚、松耦合、易于维护和扩展的系统，更好实现 Chrome 简单、稳定、高速、安全的目标。

Chrome 最终要把 UI、数据库、文件、设备、网络等模块重构为基础服务，类似操作系统底层服务，下面是 Chrome“面向服务的架构”的进程模型图：

![未来面向服务的架构](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/browser/face-to-service-many-process.png)