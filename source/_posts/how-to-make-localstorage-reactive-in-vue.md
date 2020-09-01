---
title: 「译」在Vue中如何使localstorage变为响应式
tags:
  - vue
categories:
  - 译文
date: 2020-08-13 11:35:38
---

> 原文作者：[Hunor Márton Borbély](https://css-tricks.com/author/hunorborbely/)
> 发布时间：Jun 24, 2020
> 原文地址：[How to Make localStorage Reactive in Vue](https://css-tricks.com/how-to-make-localstorage-reactive-in-vue/)

响应式是Vue的最伟大的特性之一，如果你不知道它在幕后做了什么，那么它对于你来说会显得更加神秘。就像为什么它只适用于对象和数组，而不适用于其他东西呢，比如我们今天所说的`localstorage`。

 <!-- more -->

接下来，让我们一起来回答这个问题。同时，也让`localstorage`变为响应式的。

如果你[运行下面代码](https://domlr.vercel.app/demo1.html)，则会看到`counter`的显示为静态值，不会因为在`setInterval`中修改了`localstorage`中的值而作用到页面中：

```js
new Vue({
  el: "#counter",
  data: () => ({
    counter: localStorage.getItem("counter")
  }),
  computed: {
    even() {
      return this.counter % 2 == 0;
    }
  },
  template: `<div>
    <div>Counter: {{ counter }}</div>
    <div>Counter is {{ even ? 'even' : 'odd' }}</div>
  </div>`
});
```

```js
// some-other-file.js
setInterval(() => {
  const counter = localStorage.getItem("counter");
  localStorage.setItem("counter", +counter + 1);
}, 1000);
```
如何使`localstorage`中的值发生变更时，同步更新页面中`counter`的数据呢？

对此我们有多重解决方案，最常用的方案是使用`Vuex`并保持`store`和`localstorage`中的数据同步。 但是如果我们需要更简单的东西（例如本例中的东西）怎么办？ 那就需要我们深入研究Vue的响应式系统是如何工作的。

## Vue 中的响应式系统

当Vue初始化组件实例时，它会[监听data项的变化](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/instance/state.js#L151)。这意味着它将[遍历](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/index.js#L64) data 中的所有属性，并使用[Object.defineProperty](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/index.js#L157)将它们转换为 `getter/setter`，通过为每个属性设置一个自定义的`setter`，Vue就可以监测到每个属性的变化，并且[通知](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/index.js#L191)那些需要响应变化的依赖项。它是如何将依赖项和属性之间进行建联的呢？ 通过利用`getters`进行[注册](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/index.js#L163)依赖，当触发 `computed`、`watch`和`render function`等行为时。

以上流程简写为代码的话，如下：
```js
// core/instance/state.js
function initData () {
  // ...
  observe(data)
}

// core/observer/index.js
export function observe (value) {
  // ...
  new Observer(value)
  // ...
}

export class Observer {
  // ...
  constructor (value) {
    // ...
    this.walk(value)
  }
  
  walk (obj) {
    const keys = Object.keys(obj)
    for (let i = 0; i < keys.length; i++) {
      defineReactive(obj, keys[i])
    }
  }
} 

export function defineReactive (obj, key, ...) {
  const dep = new Dep()
  // ...
  Object.defineProperty(obj, key, {
    // ...
    get() {
      // ...
      dep.depend()
      // ...
    },
    set(newVal) {
      // ...
      dep.notify()
    }
  })
}
```

那么， 为何`localstorage`不是响应式的呢？ **因为他不是一个具备属性的对象。**

但是，我们也不能用数组定义`getter`和`setter`，那为什么Vue中的数组仍然是响应式的呢？ 这是因为数组是Vue中的特例。为了具备响应式数组，[Vue在后台重写了数组的方法](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/array.js#L27)，并将它们与vue的响应式系统一起[打了个补丁](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/array.js#L42)。

那我们可以在`localstorage`上做些类似的事情吗？

## 重写 localstorage 的方法

首先尝试通过重写localStorage的方法来[修复上面的demo](https://domlr.vercel.app/demo2.html)，以追踪那些组件实例请求了`localstorage`的数据项。

```js
// localStorage项键和依赖它的Vue实例列表之间的映射
  const storeItemSubscribers = {};

  const getItem = window.localStorage.getItem;
  localStorage.getItem = (key, target) => {
    console.info("Getting", key);

    // 收集依赖的Vue实例
    if (!storeItemSubscribers[key]) storeItemSubscribers[key] = [];
    if (target) storeItemSubscribers[key].push(target);

    // 调用原始方法
    return getItem.call(localStorage, key);
  };

  const setItem = window.localStorage.setItem;
  localStorage.setItem = (key, value) => {
    console.info("Setting", key, value);

    // 更新依赖vue实例中的值
    if (storeItemSubscribers[key]) {
      storeItemSubscribers[key].forEach((dep) => {
        if (dep.hasOwnProperty(key)) dep[key] = value;
      });
    }

    // 调用原始方法
    setItem.call(localStorage, key, value);
  };
```

```js
  new Vue({
    el: "#counter",
    data: function () {
      return {
        counter: localStorage.getItem("counter", this) // We need to pass 'this' for now
      }
    },
    computed: {
      even() {
        return this.counter % 2 == 0;
      }
    },
    template: `<div>
    <div>Counter: {{ counter }}</div>
    <div>Counter is {{ even ? 'even' : 'odd' }}</div>
  </div>`
  });
```

```js
  setInterval(() => {
    const counter = localStorage.getItem("counter");
    localStorage.setItem("counter", +counter + 1);
  }, 1000);
```

在此示例中，我们重新定义`getItem`，`setItem`以便收集和通知依赖于`localStorage item`的组件。在新版本`getItem`，我们会记录哪个组件请求哪个`item`，而在`setItems`中，我们访问所有请求该项目的组件并重写其`data prop`。

为了使上面的代码起作用，我们必须将对组件实例的引用传递给`getItem`并更改其函数签名。我们也不能再使用箭头功能，因为否则我们将无法拿到正确的的`this`值。

如果我们想做得更好，就必须更深入地挖掘。例如，我们如何在不显式传递依赖者的情况下跟踪它们？

## Vue如何收集依赖关系

为了获得启发，我们可以回到Vue的响应式系统。先前我们看到，访问数据属性时，数据属性的getter将使调用者[订阅](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/index.js#L163)该属性的进一步更改。但是如何知道是谁调用的呢？当我们得到一个data时，它的getter函数没有任何关于调用者是谁的输入。Getter函数[没有输入](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/index.js#L160)。它如何知道将谁注册为依赖项的呢？ 

每个data属性维护一个需要在[Dep类](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/index.js#L142)中进行响应的依赖项列表。如果我们深入研究此类，我们可以看到，只要[注册](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/dep.js#L33)了依赖项，就已经在[static target](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/dep.js#L14)变量中定义了依赖项。这个目标是由一个非常神秘的[Watcher](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/watcher.js#L102)设置的。实际上，当数据属性更改时，将实际上[通知](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/observer/dep.js#L47)这些观察程序，并且它们将启动组件的重新呈现或计算属性的重新计算。

当Vue使该data选项observable时，它还会为每个[计算属性](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/instance/state.js#L187)函数以及所有[watch函数](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/instance/state.js#L356)（不应与Watcher类混淆）以及每个[组件实例](https://github.com/vuejs/vue/blob/0baa129d4cad44cf1847b0eaf07e95d4c71ab494/src/core/instance/lifecycle.js#L197)的render函数创建监视者。观察者就像这些功能的伴侣。他们主要做两件事：

- **它们在创建时会评估函数**。这将触发依赖项的收集。
- **当通知他们所依赖的值已更改时，他们将重新运行其功能。** 这最终将重新计算一个计算属性或重新渲染整个组件。

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/vue/vue-reactive.png)

在观察者调用其负责的功能之前，有一个重要的步骤发生了：他们将自己设置为Dep类中静态变量的目标。这样可以确保在访问反应性数据属性时将它们注册为依赖。

## 持续追踪谁调用了localstorage

我们无法*完全*做到这一点，因为我们无法使用Vue的内部机制。但是，我们可以使用Vue 的思想，即观察者可以在调用其负责的功能之前，将目标设置为静态属性。在localStorage调用之前，我们可以设置对组件实例的引用吗？

如果我们假设localStorage在设置data选项时调用了该方法，那么我们可以将其连接到beforeCreate和中created。这两个钩子函数在初始化该data选项之前和之后都会被触发，因此我们可以设置一个目标变量，然后清除该变量，并引用当前组件实例（我们可以在生命周期钩子函数中访问该实例）。然后，在我们的自定义`getter`中，我们可以将该目标注册为依赖项。

我们要做的最后一点是使这些生命周期钩子成为我们所有组件的一部分。我们可以通过整个项目的全局`mixins`来做到这一点。

```js
// A map between localStorage item keys and a list of Vue instances that depend on it
const storeItemSubscribers = {};

// The Vue instance that is currently being initialised
let target = undefined;

const getItem = window.localStorage.getItem;
localStorage.getItem = (key) => {
  console.info("Getting", key);

  // Collect dependent Vue instance
  if (!storeItemSubscribers[key]) storeItemSubscribers[key] = [];
  if (target) storeItemSubscribers[key].push(target);

  // Call the original function
  return getItem.call(localStorage, key);
};

const setItem = window.localStorage.setItem;
localStorage.setItem = (key, value) => {
  console.info("Setting", key, value);

  // Update the value in the dependent Vue instances
  if (storeItemSubscribers[key]) {
    storeItemSubscribers[key].forEach((dep) => {
      if (dep.hasOwnProperty(key)) dep[key] = value;
    });
  }
  
  // Call the original function
  setItem.call(localStorage, key, value);
};

Vue.mixin({
  beforeCreate() {
    console.log("beforeCreate", this._uid);
    target = this;
  },
  created() {
    console.log("created", this._uid);
    target = undefined;
  }
});
```

现在，当我们运行初始示例时，我们将获得一个计数器，该计数器每秒增加一个数字。

```js
new Vue({
  el: "#counter",
  data: () => ({
    counter: localStorage.getItem("counter")
  }),
  computed: {
    even() {
      return this.counter % 2 == 0;
    }
  },
  template: `<div class="component">
    <div>Counter: {{ counter }}</div>
    <div>Counter is {{ even ? 'even' : 'odd' }}</div>
  </div>`
});
```

```js
setInterval(() => {
  const counter = localStorage.getItem("counter");
  localStorage.setItem("counter", +counter + 1);
}, 1000);
```

{% codepen qBZbrQE default_tabs '500px' '700px' userId theme %}

## 结束语

当我们解决了最初的问题时，请记住这主要是一个思想实验。但是它还缺少一些功能，例如处理已删除的`item`和已卸载的组件实例。它还具有一些限制，例如组件实例的属性名称需要与`localStorage`中存储的`item`名称相同。也就是说，我们的主要目标是更好地了解Vue响应式系统在幕后的工作方式，并从中获得最大的收益。希望你也能有所收益。

如果想要进行数据持久化，可以使用[vue-persist](https://github.com/championswimmer/vuex-persist)。 如果您持续监听localStorage是否有所更改，则监听 [StorageEvent](https://developer.mozilla.org/en-US/docs/Web/API/StorageEvent) 是一个更好的主意。
