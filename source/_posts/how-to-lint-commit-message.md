---
title: 前端工程化之 git 提交信息风格统一
tags:
  - commitlint
categories:
  - 前端工程化
keywords:
  - commitlint
  - husky
date: 2020-11-05 14:27:40
---

![commitlint](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/commitlint.png)

 <!-- more -->

在一个团队中，每个人的 git 的 commit 信息都不一样，五花八门，没有一个机制很难保证规范化，如何才能规范化呢？可能你想到的是 git 的 hook 机制，去写 shell 脚本去实现。这当然可以，其实 JavaScript 有一个很好的工具可以实现这个约束，它就是 commitlint。
接下来将会讲解如何一步步的使用commitlint。

## 依赖安装

安装以下三个工具库：

```bash
yarn add -D husky @commitlint/cli @commitlint/config-conventional
```

## 配置

打开 `package.json` 文件，加入以下代码：

```js
  "commitlint": {
    "extends": [
      "@commitlint/config-conventional"
    ]
  },
  "husky": {
    "hooks": {
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  }
  ```

此时，若在项目下进行代码提交时，如果不符合既定风格的话，会提示以下信息
![a](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20201105173907.png)

对于 `commitlint`来说，一般情况下，默认的配置就够用了。但是如果想要自定义限制这些规则，不启用默认规则的话，可以在项目目录下创建 `commitlint.config.js`文件，进行更详细的配置：

```js
module.exports = {
  extends: [
    "@commitlint/config-conventional"
  ],
  rules: {
    'type-enum': [2, 'always', [
      'upd', 'feat', 'fix', 'refactor', 'docs', 'chore', 'style', 'revert'
     ]],
    'type-case': [0],
    'type-empty': [0],
    'scope-empty': [0],
    'scope-case': [0],
    'subject-full-stop': [0, 'never'],
    'subject-case': [0, 'never'],
    'header-max-length': [0, 'always', 72]
  }
};
```

rule配置说明：rule由name和配置数组组成，如：`'name:[0, 'always', 72]'`，数组中第一位为 level，可选0,1,2，0为disable，1为warning，2为error，第二位为应用与否，可选`always|never`，第三位该rule的值。

具体配置参考[官方文档](https://commitlint.js.org/#/reference-configuration)

## 使用 commitizen 生成良好格式的提交信息

[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) 格式良好的提交信息如下：

```bash
# 注意：冒号前面是需要一个空格的, 带 ？ 表示非必填信息
type(scope?): subject
body?
footer?
```

上面动图的提示信息内提到了两点 `subject` 和 `type`，如何快速生成一个符合 `commitlint` 的提交信息呢？我们可以使用 `commitizen` 这个工具库，首先进行全局安装：

```bash
yarn add global commitizen
```

在项目中进行自定义提交类型和选项，首先需要进行安装：

```bash
yarn add -D cz-customizable
```

在 package.json 中添加如下代码：

```js
"config": {
    "commitizen": {
      "path": "node_modules/cz-customizable"
    }
}
```

然后在项目根目录下新增 [.cz-config.js](https://github.com/rocwong-cn/try-commitizen/blob/master/.cz-config.js) 文件

此时，我们就可以使用 `git cz` 来替代 `git commit -m` 来进行代码提交了

![cz](https://s04.cdn.ipalfish.com/static/omp-upload-1604569978524-gitcz.gif)

## 自动生成changelog

当我们具备了格式良好的 Git message 后，就可以使用脚本一键生成该版本的变更记录了

安装：

```bash
yarn global -D conventional-changelog-cli
```

在项目的 package.json 中增加如下代码：

```bash
"scripts": {
    "changelog": "conventional-changelog -p angular -i CHANGELOG.md -s && git add CHANGELOG.md"
  },
```

之后使用 `yarn changelog` 命令即可生成 `CHANGELOG.md`。

## 资源

本文中使用的项目代码：[try-commitizen](https://github.com/rocwong-cn/try-commitizen)
