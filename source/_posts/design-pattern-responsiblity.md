---
title: 漫谈设计模式之责任链模式
tags:
  - 责任链模式
categories:
  - 设计模式
date: 2021-01-16 21:02:46
---

![pic](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210116211920.png)
 <!-- more -->

责任链模式指的是——某个请求需要多个对象进行处理，从而避免请求的发送者和接收之间的耦合关系。将这些对象连成一条链子，并沿着这条链子传递该请求，直到有对象处理它为止。

从生活中的例子可以发现，某个请求可能需要几个人的审批，即使技术经理审批完了，还需要上一级的审批。这样的例子，还有公司中的请假，少于3天的，直属Leader就可以批准，3天到7天之内就需要项目经理批准，多余7天的就需要技术总监的批准了。介绍了这么多生活中责任链模式的例子的，下面具体给出面向对象中责任链模式的定义。

责任链模式涉及的对象只有处理者角色，但由于有多个处理者，它们具有共同的处理请求的方法，所以这里抽象出一个抽象处理者角色进行代码复用.

## 实现

* 请求类

```js
// 采购请求
let PurchaseRequest = function (amount, productName) {
    this.amount = amount;
    this.productName = productName;
};
```

* 处理者接口类

```js

// 审批人,Handler
let Approver = function (name, nextApprover) {
    this.name = name;
    this.nextApprover = nextApprover;
};
Approver.prototype.processRequest = function () {
    throw new Error();  
};
```

* 处理者类

```js
// ConcreteHandler
let Manager = function (name, nextApprover) {
    Approver.call(this, name, nextApprover);
};
extend(Manager, Approver);
Manager.prototype.processRequest = function (request) {
    if (request.Amount < 10000.0)
    {
        console.log('ok');
    }
    else if (NextApprover != null)
    {
        this.nextApprover.ProcessRequest(request);
    }   
};    
    
// ConcreteHandler,副总
let VicePresident = function (name, nextApprover) {
    Approver.call(this, name, nextApprover);
};
extend(VicePresident, Approver);
VicePresident.prototype.processRequest = function (request) {
    if (request.Amount < 25000.0)
    {
        console.log('ok');
    }
    else if (NextApprover != null)
    {
        this.nextApprover.ProcessRequest(request);
    }   
};


// ConcreteHandler，总经理
let President = function (name, nextApprover) {
    Approver.call(this, name, nextApprover);
};
extend(President, Approver);
President.prototype.processRequest = function (request) {
    if (request.Amount < 100000.0)
    {
        console.log('ok');
    }
    else if (NextApprover != null)
    {
        this.nextApprover.ProcessRequest(request);
    }   
};
```

## 测试

```js
let requestTelphone = new PurchaseRequest(4000.0, "Telphone");
let requestSoftware = new PurchaseRequest(10000.0, "Visual Studio");
let requestComputers = new PurchaseRequest(40000.0, "Computers");

let manager = new Manager("LearningHard");
let Vp = new VicePresident("Tony");
let Pre = new President("BossTom");

// 设置责任链
manager.NextApprover = Vp;
Vp.NextApprover = Pre;

// 处理请求
manager.ProcessRequest(requestTelphone);
manager.ProcessRequest(requestSoftware);
manager.ProcessRequest(requestComputers);
```

## 使用场景

* 一个系统的审批需要多个对象才能完成处理的情况下，例如请假系统等。
* 代码中存在多个if-else语句的情况下，此时可以考虑使用责任链模式来对代码进行重构。

## 特点

* 降低了请求的发送者和接收者之间的耦合。
* 把多个条件判定分散到各个处理类中，使得代码更加清晰，责任更加明确。

## 缺点

* 在找到正确的处理对象之前，所有的条件判定都要执行一遍，当责任链过长时，可能会引起性能的问题, 可能导致某个请求不被处理。

## 总结

*责任链降低了请求端和接收端之间的耦合，使多个对象都有机会处理某个请求。使得责任分割, 更具体, 有助于拓展
