---
title: js设计模式之观察者模式（发布订阅）初窥
date: 2018-06-23 10:53:17
tags:
- 观察者模式
categories:
- 设计模式
---

> 观察者模式又叫做发布订阅模式，它定义了一种一对多的关系，让多个观察者对象同时监听某一个主题对象，这个主题对象的状态发生改变时就会通知所有的观察者对象。它是由两类对象组成：发布者和观察者。发布者负责发布事件，同事观察者通过订阅这些事件来观察该主题，发布者和订阅者是完全解耦的，彼此不知道对方的存在，两者仅仅共享一个自定义事件的名称。

<!-- more -->

如果你写过js的`onclick`事件，那么你就用过观察者模式：

```js
div.onclick = function click(){
    console.log('clicked me !');
}
```
这里的`function click`订阅了`div`的`click`事件，当我们的鼠标执行点击操作时，事件发布，对应的`function`就会执行，这个`function click`就是一个观察者。

为了方便理解，我们可以具象化的将这个概念理解为`我`与`微信公众号`之间的关系。比如你关注（订阅）了`公众号A`，但是`公众号A`的消息推送是不确定的，你不知道他何时推送，但是你总不能时时刻刻的去打开它的聊天窗口去刷新，去询问吧，而且就算你一直的在刷新这个界面，你也得不到最新推送。你需要做的就是静静等待，等新推送来了之后，微信会自动提示你。
在这个🌰里面，`我`就是一个观察者，`我`订阅了发布者`公众号A`，订阅之后`我`可以继续去做我喜欢的其他事情，与`公众号A`互不干扰，只有当它告诉我说："😎小伙子，你的新推送来了，快去看看吧！"的时候，你再去看就可以了。
用代码来实现这个简单的逻辑的话就是：

```js
Me.on('new_push',function(){
    // 去查看新的推送信息
});

//公众号A发布新推送
PublicA.emit('new_push');
```
* 一个简单的js的观察者模式实现：

```js
var Event = {
	on:function(eventName,callback){
		if(!this.handlers) this.handlers = {};
		if(!this.handlers[eventName])this.handlers[eventName]=[];
		this.handlers[eventName].push(callback);
	},
	emit:function(eventName){
		var args = Array.prototype.slice.call(arguments,1);
		var events = this.handlers[eventName];
		var that = this;
		events.forEach(function(func,i){
			func.call(that,args[i])
		});
	}
};
Event.on('test',function(result){
	console.log(result);
});
Event.on('test',function(){
	console.log('world ! ');
});
Event.emit('test','Hello');//会依次输出 Hello,world ! 

```

* 实现一个可以发布和解除订阅的类：

```js
class EmitterEvent {
  constructor() {
  //构造器。实例上创建一个事件池
    this._event = {};
  }
  //on 订阅
  on (eventName, handler) {
  // 根据eventName，事件池有对应的事件数组，
  // 如果eventName已经有对应的事件数组就push，没有就新建一个。
  // 严谨一点应该判断handler的类型，是不是function
    if(this._event[eventName]) {
      this._event[eventName].push(handler);
    } else {
      this._event[eventName] = [handler];
    }
  }
  emit (eventName) {
  // 根据eventName找到对应数组
    var events = this._event[eventName];
  //  取一下传进来的参数，方便给执行的函数
    var otherArgs = Array.prototype.slice.call(arguments,1);
    var that = this;
    if(events) {
      events.forEach((event) => {
        event.apply(that, otherArgs);
      })
    }
  }
  // 解除订阅
  off (eventName, handler) {
    var events = this._event[eventName];
    if(events) {
      this._event[eventName] = events.filter((event) => {
        return event !== handler;
      })
    }
  }
  // 订阅以后，emit 发布执行一次后自动解除订阅
  once (eventName, handler) {
    var that = this;
    function func () {
      var args = Array.prototype.slice.call(arguments,0);
      handler.apply(that, args);
      this.off(eventName,func);
    }
    this.on(eventName, func);
  }
}

var event = new EmitterEvent();
function a (something) {
  console.log(something,'aa-aa');
}
function b (something) {
  console.log(something);
}
 event.once('dosomething',a);
 event.emit('dosomething', 'hahaha');
```
当我们需要用的时候，只需要继承一下这个EmitterEvent类。要操作的实例就可以用on,emit方法，也就是可以用发布订阅。

* 最后
发布订阅的第三方库还是很多的，node的build-in库里面也封装了，浏览器也有事件触发的机制。而且像现在的一些流行的框架的渲染机制很多也是基于监听、发布订阅这种方式来实现的，比如VUE等。。