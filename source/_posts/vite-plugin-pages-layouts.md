---
title: ⚡️ 懒癌福利！一种全新的路由组织方式 —— 基于 vite 的插件介绍
tags:
  - vite
categories:
  - vue
keywords:
  - vue
  - vite
date: 2021-05-27 15:15:40
---
![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210527162713.png)

以往我们在基于 `Vue` 或者 `react` 做页面开发时，往往需要通过安装 `vue-router` 或者 `react-router` ，然后手动编写其路由组织文件来完成文件对路由结构系统的映射，页面少的时候配置起来还不繁琐，但是当开发一些大型的中后台B端项目的时候，整个配置文件就会很大。有时候如果目录文件的组织结果和路由层级对应不上的话，在日后的开发维护中找起对应路由的文件时就会很繁琐。

 <!-- more -->

`vite-plugin-pages` 就很好的解决了这个问题，无需任何路由组织文件，文件系统即路由系统！

> vue-plugin-pages 基于文件系统的路由生成器

根据`pages`文件夹下的文件组织结构自动生成一个路由数组，输入到`Vue Router` 实例中，文件组件结构决定你的路由层级，每次在`pages`目录下新增一个`.vue`文件后，即可自动为你创建路由，无需其他配置！

当然 `pages` 目录可以替换为你任何想要的目录名称，如`views`。 除了`.vue`文件，也支持 `markdown` 等格式在文件。

目前对 `react` 的支持尚在实验阶段，当然你也可以访问[它的主页](https://www.npmjs.com/package/vite-plugin-pages)来了解更多内容。

除此之外，对于常见的路由方式，它也提供了支持：

### 基础的路由映射

`vue-plugin-pages`（后称 VPP ）会自动将`pages`目录下的文件映射成相同名字的路由：

- src/pages/users.vue -> /users
- src/pages/users/profile.vue -> /users/profile
- src/pages/settings.vue -> /settings

### 默认索引路由

以 `index` 命名的文件会自动当做路由的索引页：

- src/pages/index.vue -> /
- src/pages/users/index.vue -> /users

### 动态路由

使用方括号来表示动态路由，文件夹和文件都可以动态哦：

- src/pages/users/[id].vue -> /users/:id (/users/one)
- src/[user]/settings.vue -> /:user/settings (/one/settings)

动态参数需要通过 `props` 传入到目标页面，如 `src/pages/users/[id].vue` 路由 `/users/abc` 将需要传递如下参数：

```json
{ "id": "abc" }
```

### 嵌套路由

我们可以利用 `Vue Router` 子路由来创建嵌套布局。可以通过为父组件定义与包含子路由的目录相同的名称来定义父组件。

当我们有如下的目录结构时：

```bash
src/pages/
  ├── users/
  │  ├── [id].vue
  │  └── index.vue
  └── users.vue
```

将会得到如下的路由配置：

```bash
[
  {
    path: '/users',
    component: '/src/pages/users.vue',
    children: [
      {
        path: '',
        component: '/src/pages/users/index.vue',
        name: 'users'
      },
      {
        path: ':id',
        component: '/src/pages/users/[id].vue',
        name: 'users-id'
      }
    ]
  }
]
```

### 捕获所有路由

捕获所有路由使用包含省略号的方括号来表示：

- src/pages/[...all].vue -> /* (/non-existent-page)

省略号后的文字将用于命名路由，以及用作传递路由参数的属性名称。


## 配置及实现

首先使用vite新创建一个vue项目：

```bash
# yarn
yarn create @vitejs/app my-vue-app --template vue-ts

cd my-vue-app

yarn add -D vite-plugin-pages

yarn add vue-router@next

```

然后将以下代码添加到你的`vite.config.js`中：

```js
import Vue from '@vitejs/plugin-vue';
import Pages from 'vite-plugin-pages';

export default {
  plugins: [
    Vue(),
    Pages()
  ]
};
```

修改 `main.ts`:

```js
import { createApp } from 'vue';
import { createRouter, createWebHistory } from 'vue-router';
import routes from 'virtual:generated-pages';
import App from './App.vue';

console.log(routes);

const router = createRouter({
  history: createWebHistory(),
  routes,
});

const app = createApp(App);

app.use(router);

app.mount('#app');
```

修改 `App.vue`：

```html
<template>
  <router-view />
</template>
```

到此为止已经完成了所有的配置及前置工作，接下来我们在 `src` 目录下创建 `pages` 目录，然后按照你的喜好添加文件吧，如：

```bash
├── [...all].vue # 捕获所有路由，常用于404
├── about
│   └── index.vue
├── about.vue # 通过/about来访问该页面
├── blog  # 通过/blog来访问
│   ├── [id].vue # 动态路由
│   ├── index.vue
│   └── today
├── components.vue
└── index.vue # 当访问本地IP和端口号时的默认页面
```

如果想要添加其他的文件目录，可以通过修改`vite.config.js`中的`Pages - pagesDir`属性进行配置。

以上目录的完整代码可以访问 [try-vite-plugins](https://github.com/rocwong-cn/try-vite-plugins) 来获取。

原文链接：[]()