---
title: 漫谈设计模式之门面模式
tags:
  - 门面模式
categories:
  - 设计模式
keywords:
  - 设计模式
  - 门面模式
date: 2021-01-30 20:31:22
---

![门面模式](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210130205410.png)

 <!-- more -->

门面模式又叫做外观模式，是常见的设计模式之一。在代码中可能无意之中就会使用到门面模式，甚至一些第三方开源 SDK 为了简化 API 调用，减少内部细节的暴露，可能会提供类似门面模式的接口，方便开发者使用。

来看一下外观模式的定义：
> 要求一个子系统的外部与其内部的通信必须通过一个统一的对象进行。门面模式提供一个高层次的接口，使得子系统更易于使用。

## 实现

下面通过一个空调系统，来解释门面模式的使用。首先， 定义空调的开关系统：

```ts
 class PowerSystem {

    private boolean started;

    public void powerOn() {
        if (!started) {
            console.log("启动空调");
            started = true;
        }
    }

    public void powerOff() {
        if (started) {
            console.log("关闭空调");
            started = false;
        }
    }
}
```

然后是风扇系统：

```ts
 class FanSystem {

    public void adjustDegree() {
        console.log("调整风扇角度");
    }

    public void adjustPower() {
        console.log("调整风速大小");
    }
}
```

最后定义温控系统：

```ts
 class TempSystem {

    public void turnUp() {
        console.log("调高温度");
    }

    public void turnDown() {
        console.log("调低温度");
    }
}
```

三个与空调相关的子系统定义好之后，就来定义我们的门面（Facade）对象了：

```js
 class AirController {

    private FanSystem fanSystem = new FanSystem();
    private PowerSystem powerSystem = new PowerSystem();
    private TempSystem tempSystem = new TempSystem();

    public void adjustDegree() {
        powerSystem.powerOn();
        fanSystem.adjustDegree();
    }

    public void adjustWindPower() {
        powerSystem.powerOn();
        fanSystem.adjustPower();
    }

    public void turnUp() {
        powerSystem.powerOn();
        tempSystem.turnUp();
    }

    public void turnDown() {
        powerSystem.powerOn();
        tempSystem.turnDown();
    }

    public void powerOff() {
        powerSystem.powerOff();
    }

    public void powerOn() {
        powerSystem.powerOn();
    }
}
```

定义客户类，模拟空调系统调用：

```js
class Client {
    public static mainMethod() {
        AirController airController = new AirController();
        airController.turnDown();
        airController.adjustDegree();
        airController.adjustWindPower();
        airController.powerOff();
    }
}
// 调用
Client.mainMethod();
```

打印结果：

```js
启动空调
调低温度
调整风扇角度
调整风速大小
关闭空调
```

不难理解，门面模式实现了各子系统之间的关联，同时不必在意子系统内部的具体实现，通过统一一个 `AirController` 门面来提供给客户端调用，简化使用。

## 总结

门面模式的优点显而易见，对于其缺点有几点需要说明，通过上面的例子或多或少可以看出门面模式存在以下几个问题： - 由于子系统的增加或其提供的接口的增加，会导致门面类接口膨胀冗余； - 外观类没有遵循开闭原则，不符合“对修改关闭，对扩展开放”的定义，当业务变更时，需要直接对外观类进行修改。
