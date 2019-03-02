---
title: 深入理解__proto__和prototype
date: 2018-05-10 20:20:21
tags:
- 原型链
categories:
- 基础原理
---

最近在收集面试题的时候发现了一些考查prototype的题目，然而很多都是一知半解的看完了，今天就深入理解一下prototype和\__proto\__ 。

首先要明确的是：
1. 在JS里，万物皆对象。方法（Function）是对象，方法的原型(Function.prototype)是对象。因此，它们都会具有对象共有的特点。即：对象具有属性\__proto\__，可称为隐式原型，一个对象的隐式原型指向构造该对象的构造函数的原型，这也保证了实例能够访问在构造函数原型中定义的属性和方法。
如：

<!-- more -->

```js
function Person(){}
Person.prototype.name = 'Roc';
Person.prototype.getName = function(){
    return this.name;
}
console.log(Person.prototype);//{name: "Roc", getName: ƒ, constructor: ƒ}
var p = new Person();
console.log(p.\__proto\___);//{name: "Roc", getName: ƒ, constructor: ƒ}
console.log(p.constructor.prototype);//{name: "Roc", getName: ƒ, constructor: ƒ}

```
由此可以得出以上结论，以及：
```js
instance.constructor.prototype = instance.\__proto\__ 

```

2. 方法(Function)这个特殊的对象，除了和其他对象一样有上述_proto_属性之外，还有自己特有的属性——原型属性（prototype），这个属性是一个指针，指向一个对象，这个对象的用途就是包含所有实例共享的属性和方法（我们把这个对象叫做原型对象）。原型对象也有一个属性，叫做constructor，这个属性包含了一个指针，指回原构造函数。

   {% img http://rocwong.oss-cn-beijing.aliyuncs.com/e83bca5f1d1e6bf359d1f75727968c11_r.jpg?Expires=1551454962&OSSAccessKeyId=TMP.AQEziqlazK_vGvNGPqzJu7yjdfGBLy9wQLs2jSIB-lymoRkmDZk2l3d2CNtkAAAwLAIUUUlWFhMnxeed4AZZY6rwLT-tankCFBvheikGPYe_HvmeqKwYPCv5o08Q&Signature=q6e3xOGBKJA1EhXGT%2FGKe1%2F5rms%3D [prototype] %}

好啦，知道了这两个基本点，我们来看看上面这副图。

* 构造函数Foo()构造函数的原型属性Foo.prototype指向了原型对象，在原型对象里有共有的方法，所有构造函数声明的实例（这里是f1，f2）都可以共享这个方法。
* 原型对象Foo.prototypeFoo.prototype保存着实例共享的方法，有一个指针constructor指回构造函数。
* 实例f1和f2是Foo这个对象的两个实例，这两个对象也有属性\__proto\__，指向构造函数的原型对象，这样子就可以像上面1所说的访问原型对象的所有方法啦。
* 另外：构造函数Foo()除了是方法，也是对象啊，它也有\__proto\__属性，指向谁呢？指向它的构造函数的原型对象呗。函数的构造函数不就是Function嘛，因此这里的\__proto\__指向了Function.prototype。其实除了Foo()，Function(), Object()也是一样的道理。原型对象也是对象啊，它的\__proto\__属性，又指向谁呢？同理，指向它的构造函数的原型对象呗。这里是Object.prototype.最后，Object.prototype的\__proto\__属性指向null。
**> 总结**：
* 对象有属性\__proto\__,指向该对象的构造函数的原型对象。
* 方法除了有属性\__proto\__,还有属性prototype，prototype指向该方法的原型对象。

（本文系转载）
作者：doris
链接：https://www.zhihu.com/question/34183746/answer/58155878
来源：知乎