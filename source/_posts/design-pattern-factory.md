---
title: 漫谈设计模式之工厂模式
tags:
  - 工厂模式
categories:
  - 设计模式
date: 2020-06-05 22:30:47
---

  ![banner](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/factory-pattern/banner.png)

## 什么是工厂模式？

工厂模式（Factory Pattern）是最常用的设计模式之一。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。

<!-- more -->

在工厂模式中，我们在创建对象时不会对客户端暴露创建逻辑，并且是通过使用一个共同的接口来指向新创建的对象。

工厂模式的适用场合：
1. 动态实现；
2. 节省设置开销；
3. 用许多小型对象组成一个大对象；

按照抽象程度的不同，工厂模式又可以分为简单工厂、工厂方法和抽象工厂。 如果你之前只接触过JavaScript而没有接触过其他面向对象的语言的话，可能对抽象`abstract`这个词有点不熟悉，下面我们就说一个小例子来理解一下抽象的概念：

## 什么是抽象（abstract）？

> 说有一天你去面馆吃饭，一坐下就对服务员说：“给我来点吃的，快点，我着急上班。” 服务员很纳闷，心想我家有几十种面，你到底要吃什么呢？ 就问你：“先生，你要吃什么饭？” 你本来就很着急，这个时候服务员还没给你下单，竟然还在问你，你就很不耐烦的说：“当时要吃面了，我每天不都是面吗” 服务员虽然看你着急，但是还是继续说到：“先生，你要吃是什么面？大份还是小份？吃辣还是不吃辣？要葱花香菜吗？” 这个时候你才明白过来，哦~ 原来是我的表述有问题，没有正确的传达我的意图。于是你就耐心的说：“ 要一个大份，微辣，葱花香菜正常的牛肉面。” 服务员这才给你下单。

上面我们说到的`牛肉面`就是一个实例对象，`面馆`就是生产实例对象的一个工厂，我们可以把它当做是一个工厂函数，里面有各式各样的面，由于你给这个函数传递了正确的参数：*大份、微辣、要葱花香菜、牛肉面*，所以你最终得到了一碗你想要的牛肉面。 但是一开始你只说了*要点吃的、吃碗面*这都没有具体到生产对象所需要的所有参数，导致服务员一直不知道你想要什么，太抽象了，**这种将复杂事物的一个或多个共有特征抽取出来的思维过程就是抽象**。

如果你已经明白了抽象的概念，那么对下面理解抽象工厂会很有帮助。

## 简单工厂模式

简单工厂模式也叫做静态工厂模式，该模式对对象创建管理方式最为简单，因为其仅仅简单的对不同类对象的创建进行了一层薄薄的封装，该模式通过向工厂传递类型来指定要创建的对象。下面我们继续使用刚刚的牛肉面来讲解该模式：

```js
const noodlesFactory = function(type) {
    function BeefNoodles() {
        this.name = '牛肉面';
        this.spicy = '微辣';
    }

    function MuttonNoodles() {
        this.name = '羊肉面';
        this.spicy = '特辣';
    }

    function EggNoodles() {
        this.name = '鸡蛋面';
        this.spicy = '不要辣';
    }

    switch (type) {
        case 'beefNoodles':
            return new BeefNoodles();
        case 'muttonNoodles':
            return new MuttonNoodles();
        case 'eggNoodles':
            return new EggNoodles();
        default:
            throw new Error('传入的参数错误，可选：beefNoodles、muttonNoodles、eggNoodles');
    }
}

const beefNoodles = noodlesFactory('beefNoodles');
console.log('beefNoodles', beefNoodles); // { name: '牛肉面', spicy: '微辣'}
const muttonNoodles = noodlesFactory('muttonNoodles');
console.log('muttonNoodles', muttonNoodles); // { name: '羊肉面', spicy: '特辣' }
const eggNoodles = noodlesFactory('eggNoodles');
console.log('eggNoodles', eggNoodles); // { name: '鸡蛋面', spicy: '不要辣'}
```

`noodlesFactory`就是一个简单工厂，在该函数中有三个构造函数分别对应不同的面条种类。 当我们调用工厂函数时，只需要传递`beefNoodles, muttonNoodles, eggNoodles` 这三个可选参数中的一个获取对应的实例对象即可。

简单工厂的优点在于，你只需要一个正确的餐护士，就可以获取到你所需要的对象，而无需知道其生产产品的具体细节。

但是，在函数内包含了所有对象的创建逻辑（构造函数）和判断逻辑的代码，每增加新的构造函数还需要修改判断逻辑代码。当我们的对象实例不是上面的三个，而是30个甚至更多的时候，这个函数会成为一个庞大的超级函数，变的难以维护。

所以，**简单工厂只能用于创建对象数量较少，对象的创建逻辑不复杂的时候使用。**


## 工厂方式模式

工厂方法模式的本意是将实际创建对象的工作推迟到子类中，这样核心类就变成了抽象类。但是在js中很难像传统面向对象那样去实现创建抽象类。所以在js中我们只需要参考它的核心思想即可。我们可以将工厂方法看做是一个实例化对象的工厂类。

在简单工厂模式中，我们每添加一个构造函数需要修改两处代码。现在我们使用工厂方法模式改造上面的代码，刚才提到，工厂方法我们只把它看作是一个实例化对象的工厂，它只做实例化对象这一件事情！ 我们采用安全模式创建对象。

```js
// 安全模式创建的工厂方法函数
const NoodlesFactory = function(type) {
    if (this instanceof NoodlesFactory) {
        return new this[type]();
    }
    return new NoodlesFactory(type);
}

// 工厂方法函数的原型中设置所有对象的构造函数
NoodlesFactory.prototype = {
    BeefNoodles: function() {
        this.name = '牛肉面';
        this.spicy = '微辣';
    },
    MuttonNoodles: function() {
        this.name = '羊肉面';
        this.spicy = '特辣';
    },
    EggNoodles: function() {
        this.name = '鸡蛋面';
        this.spicy = '不要辣';
    }
}

// 注意：以下的入参是工厂方法函数的原型中设置的构造函数，首字母大写
const beefNoodles = NoodlesFactory('BeefNoodles');
console.log('beefNoodles', beefNoodles); // { name: '牛肉面', spicy: '微辣'}
const muttonNoodles = NoodlesFactory('MuttonNoodles');
console.log('muttonNoodles', muttonNoodles); // { name: '羊肉面', spicy: '特辣' }
const eggNoodles = NoodlesFactory('EggNoodles');
console.log('eggNoodles', eggNoodles); // { name: '鸡蛋面', spicy: '不要辣'}
```

上面的这段代码就很好的解决了每添加一个构造函数就需要修改两处代码的问题，如果我们需要添加新的实例，只需要在`NoodlesFactory.prototype`中添加。例如，我们需要添加一个`VegetableNoodles`:
```js
NoodlesFactory.prototype = {
  //....
  VegetableNoodles: function() {
    this.name = '蔬菜面'；
    this.spicy = '变态辣'；
  }
}

//调用
const vegetableNoodles = NoodlesFactory('VegetableNoodles');
```

## 抽象工厂模式

抽象工厂模式（Abstract Factory Pattern）是围绕一个超级工厂创建其他工厂。该超级工厂又称为其他工厂的工厂。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。
在抽象工厂模式中，接口是负责创建一个相关对象的工厂，不需要显式指定它们的类。每个生成的工厂都能按照工厂模式提供对象。

抽象工厂模式的代码基于typescript来实现比较更能说明问题，我在GitHub创建了一个仓库，您可以[移步此处](https://github.com/rocwong-cn/design-pattern/tree/master/src/patterns/factory-pattern/abstract-factory)来看代码实现。

优点：当一个产品族中的多个对象被设计成一起工作时，它能保证客户端始终只使用同一个产品族中的对象。

缺点：产品族扩展非常困难，要增加一个系列的某一产品，既要在抽象的 Creator 里加代码，又要在具体的里面加代码。

使用场景： 1、QQ 换皮肤，一整套一起换。 2、生成不同操作系统的程序。

注意事项：产品族难扩展，产品等级易扩展。


## 总结

上面说的三种工厂模式，都是属于创建型的设计模式。简单工厂模式又叫静态工厂方法，用来创建某一种产品对象的实例，用来创建单一对象；工厂方法模式是将创建实例推迟到子类中进行；抽象工厂模式是对类的工厂抽象用来创建产品类簇，不负责创建某一类产品的实例。在实际的业务中，需要根据实际的业务复杂度来选择合适的模式。对于非大型的前端应用来说，灵活使用简单工厂其实就能解决大部分问题。




