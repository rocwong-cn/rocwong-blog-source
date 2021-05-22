---
title: 【vue3源码学习系列】一、先导篇：看懂 vue.js 3.0 的优化
tags:
  - vue
categories:
  - 学习笔记
date: 2021-05-22 17:06:22
---

今天线上观看了 `vueconf`，对于很多嘉宾的分享一些底层原理的地方，思路明显跟不上；回想起来，我也从`vue2.x`开始，使用了两年多的`vue`了，但是对于很多底层的实现机制了解的并不是很深入。最近在一些项目中使用了`vue3 + vite`来开发，发现`vue3和vite`很多地方都是革命性的改动，对此很感兴趣，于是就给自己挖了这个大坑，从学习`vue3`源码开始，一步一步将这座大山翻过去。

 <!-- more -->

## why ?

为什么要学习 `vue.js` 源码？

- 有助于提升 JavaScript 功底
- 提升工作效率，形成学习与成长的良性循环
- 借鉴优秀源码的经验，站在巨人的肩膀上看世界
- 提升自己解读源码的能力

为什么却很少有人愿意去读源码呢？

- 因为学习源码很枯燥，不像开发项目那样能够很快得到反馈、看到立竿见影的效果
- 学习源码相对于开发项目来说更抽象，理解起来也难，很多人学着学着就放弃了
- 还有很多人想学，却不得法门

接下来，就一起来看看 vue 3.0 都做了哪些方面的优化：

## 源码优化

- 目录架构调整
  
主要体现在使用`monorepo` 和 `typescript` 管理和开发源码，这样做的目的是提升自身代码可维护性；

<div style="display:flex; flex:1">
  <div style="display:flex; flex:1">
    <img style="width:100%;height:100%" src="https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210522222347.png">
  </div>
  <div style="display:flex; flex:1">
    <img style="width:100%;height:100%" src="https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210522173644.png">
  </div>
</div>

<div style="text-align:center; color: #999">「vue 2.x 和 vue 3.x 源码目录对比」 </div>

- 抛弃了 `Flow` 来使用 `typescript` 来重写了 `Vue` 源码。

## 性能优化

- 移除了一些冷门的feature：filter、inline-template等
- 引入tree-shaking技术来进行源码体积优化
  
依赖ES2015模块语法的静态结构（即 import和export），通过编译阶段的静态分析，找到没有引入的模块并打上标记。
如果你在项目中没有引入 `Transition`、`keepAlive`等组件，那么他们对应的代码就不会打包，这样也就间接的达到了减少项目引入的 `vue.js`包体积的目的。

## 数据劫持优化

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210522175029.png)

**vue 2.x 数据劫持的缺陷**

- 由于使用了 `Object.defineProperty` 这个api劫持数据的 `getter` 和 `setter` ，所以需要事先知道拦截的`key`是什么，所以它并不能检测对象属性的添加和删除，尽管 `vue2.x` 为了改善而提供了 `$set` 和 `$delete`，但是还是增加了额外的心智负担。
- 对于嵌套层级较深的对象，需要逐层遍历递归这个对象，会对性能有所影响。

**vue 3.x 使用 proxy 来直接劫持整个对象的变化**
值得注意的是，proxy api 并不能监听到内部深层次的对象变化，因为 vue 3.0 的处理方式是在 getter中去神递归响应式。

这样的好处是真正访问到的内部对象才会变成响应式，而不是无脑递归，这样无疑也在很大程度上提升了性能。

## 编译优化

首先看下Vue的编译过程
![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210522220127.png)

vue 2.x 的时候，当我们有一个这样的代码块的时候：

```html
<div>
  <p>hello</p>
  <p>I</p>
  <p>am</p>
  <p>{{yourName}}</p>
  <p>!</p>
</div>
```

可以看出，只有第四个p标签的值是动态的，但是当vue 2.x 进行diff的时候会从父级div，逐级逐个标签进行diff，不管我们的值是动态还是静态的，这无疑会造成很大的性能浪费。

Vue3通过编译阶段对静态模板的分析，编译生成了Block tree，它是一个将模板基于**动态节点**指令切割的嵌套区块，每个区块内部的节点结构是固定的，每个区块只需要以一个Array来追踪自身包含的动态节点。 借助Block tree， vue.js 将 vnode 更新性能与模板整体大小相关**提升为与动态内容的数量相关**。

除此之外，在编译阶段还包含了对 slot 的编译优化、事件侦听函数的缓存优化，并且在运行时**重写了diff算法**。

## 语法优化：Composition API

vue 1.x 及 vue 2.x 编写组件本质上就是在编写一个“包含了描述组件选项的对象”，一般称之为 `Option API`，其设计是按照 `method`,`computed`,`data`,`props` 等不同的选项进行分类，其编写习惯类似于我们原来使用 `jquery` 的插件（如轮播图）时，传入的配置参数。 当组件比较小的时候，这种分类一目了然；但是在大型组件中，一个组件可能有多个逻辑关注点，如果要修改一个逻辑点的代码时，就需要在单个文件中不断的上下切换和寻找，十分痛苦。即便后来提出了mixins的方案来做业务逻辑的封装切分，但是mixins本身也有很多问题，如相同属性和方法字段的覆盖策略优先级问题、data内字段在mixins内修改后对其他mixins或者主文件造成的副作用问题等；

vue 3.0 提供了一种新的 API：Composition API,当然其也是一个独立的[可安装模块 @vue/composition-api](https://www.npmjs.com/package/@vue/composition-api)，就是将某个逻辑关注点的相关代码全都放在一个函数里面，这样当需要修改一个功能是，就不需要在单个文件中跳来跳去。很大程度上也能做到某些逻辑复用。

从颜色上来对比两种API在逻辑较多时，一个单文件的呈现：

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210522224841.png)

**Composition API 特点**

- 出了逻辑复用方面的优势，其也会有更好的类型支持；
- 因为其本质上是函数，所以在调用函数时，自然所有的类型就被推导出来了，不想 option api 所有的东西都使用 this；
- 另外，Composition API 对 tree-shaking优化，代码也更容易压缩；
- 当然，Composition API 只是一个新的写法增强，在vue3里面并不是强制使用的，如果你的代码足够简单，完全可以继续使用 SFC Option API 的方式进行开发

## 引入 RFC： 使每个版本的改动都更加可控

- 维护者每个版本的改动都通 RFC 来决定其更改内容
- 使用者也可以通过阅读 RFC 来了解每个 feature 采用或被废弃掉的前因后果

## 最后

由于vue 3.0 是使用 ES2015 的语法进行开发的，有些 API 如 Proxy 是没有 polyfill 的，这就意味着官方需要单独出一个 IE11 compat 版本来支持 IE11的，不过从最近的 `vueconf` 上了解到，尤大本人表示短时间内不会对 IE11 做任何兼容性的改动，而且最近微软官方也表示 IE11 马上也要停止维护了，更看好 Edge 浏览器。 

对于目前的 vue 2.0 官方打算继续维护18个月，今年会有最后一个 major version 的发布 vue 2.7，之后就只有bugfix版本了。