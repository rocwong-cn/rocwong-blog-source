---
title: 百度前端（内部财务方向）线下测试题分析20200720
tags:
  - 面试经历
categories:
  - 基础原理
date: 2020-08-01 18:33:10
---

在这次找工作的过程中，百度整体的流程还是比较规范的，虽然因为第一次去百度大厦的时候被HR告知一面面试官因为会议原因要临时取消面试，改约其他时间。但是之后来到和所有的面试官聊天的过程中，还是感受到了大厂范儿。

 <!-- more -->

相较于其他公司喜欢问原理、问机制，百度的几面中更关注的是你在工作中是如何运用你所掌握的框架知识的，工作中是如何平衡业务和技术的，会通过一些工作中很实际的问题来一层层的深入讨论，这点我觉得非常好。

下面主要看一下百度线下测试题部分，看看百度更关注一个前端的基本素养是什么。


## 样式相关

### 1.1 假设有如下的 DOM 结构 & 样式 ( ⼩提示, 可以先往下看, 然后再回来看这⼀⼤坨 css )

``` html
<style>
body {
  background: #fff !important;
 }
.root {
  border: 3px #000 solid;
  width: 200px;
 }
.root div {
  box-sizing: border-box;
  border: 1px #000 solid;
  background-color: #fff;
 }
.div-a {
  position: relative;
  z-index: 100;
  top: 50px;
  width: 200px;
  height: 100px;
 }
.div-b {
  position: absolute;
  z-index: 300;
  top: 80px;
  width: 100px;
  height: 50px;
 }
.div-c {
  position: absolute;
  z-index: 200;
  width: 50px;
  height: 100px;
 }
</style>

<div class="root"> 
  <div class="div-a"> 
    <div class="div-b"></div>
  </div>
  <div class="div-c"></div>
</div>
```

### 问题

- 请问以上 HTML ⽚段, 对应以下的哪⼀个渲染效果?
- 请简要分析⼀下你的推导思路?
  - 提示, 这个⼩问是必答的, 我们需要参考你的实际推导依据

![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/baidu/baidu-a.png)
![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/baidu/baidu-b.png)
![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/baidu/baidu-c.png)
![img](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/baidu/baidu-d.png)

### 作答

选B。

⾸先，针对 root ⾼度，由于 root 下的元素只有 div-a 是 relative ，在⽂档流中；⼜因为所有 div 的盒模型是使⽤的标准盒模型，所以 root 的⾼度就等于 div-a 的⾼度 200px + 其上下边框的⾼度 3px*2 = 206px ;

然后， div-a 相对其正常位置向下偏移 50px (top: 50px) , div-b 是绝对定位，其定位是相对于⽗级 div-a 进⾏的，向下偏移 80px (top:80px) ，由此可以排除C、D选项。

A、B选项中的不同点在于针对 div-c 和 div-b 的 z-index ，由于 div-b 的⽗级元素 div-a 的 z-index 为 100px ，根据**从⽗规则**，所以 div-b 的 z-index 会被降级，⽽ div-c 的 z-index 值⼤于 div-a 的 z-index ，所以 div-c 在 div-b 的上⾯。故选B。

### 1.2 简要介绍⼀下, 你在项⽬中, 如何管理各个元素的 z-index ?

- 制定使⽤z-index的规范，⽐如 popover，modal，colorpicker 之类的组件，按照组件特性指定其层级的⾼低规范。另外业务布局中如果⽤到了z-index，尽量控制其层级为较低的规范内，如布局中的z-index尽量使⽤1xx，弹出层类的组件使⽤2xx等。
- 全局维护⼀个获取z-index的⽅法，每次调⽤时数值递增1

### 1.3 简要介绍⼀下, 你如何在项⽬中管理样式的? 如何避免不同⻚⾯ / 模块中, 样式的互相影响 ?

- ⽬前项⽬中使⽤的是 BEM 规则，通过区分模块和元素来进⾏样式命名。
- 通过 css modules 将css进⾏分模块管理。

## ⽹络相关

### 2.1 : 什么是同源策略和跨域? 解决跨域的⽅法有哪些 ?

同源策略是指协议、端⼝、域名相同，也就是在同⼀个域中。

⾮同源受到的限制有：cookie⽆法读取、dom⽆法获取、ajax请求⽆法发送。

跨域：两个不同域（协议、端⼝、域名不同）之间进⾏请求。

解决跨域的⽅法：

- JSONP，通过动态创建⼀个script标签，script标签的src属性是没有跨域的限制的。
- cors，服务端在response时增加⼀些头信息：
  - Access-Control-Allow-Origin: http://ip:port
必需项, 值为请求头中的 Origin 的值.
  - Access-Control-Allow-Credentials:true
可选项, 值为boolean, 表示是否允许浏览器发送cookie, 需要在服务器配置.
  - Access-Control-Allow-Methods:
必需项, 允许跨域请求的请求⽅式.
- Nginx做反向代理
- 开发环境跨域使⽤ webpack-dev-server 的 proxy

### 2.2 : 列举⼀下 HTTP 中关于 "资源缓存" 的头部指令 (Head) 有哪些 ? 并简要介绍⼀下设置的规则 ?

强制缓存
- Expires 指定⼀个缓存的过期时间，如果当次请求的资源在该过期时间之前，则命中缓存。缺点是
因为这个时间是⼀个绝对时间，所以当客户端本地时间被修改后，服务器与客户端时间偏差变⼤会
导致缓存混乱。
- Cache-Control ⼀般通过 max-age 指定⼀个相对时间，单位是秒。优先级⾼于 Expires 。其他常⽤
的取值有：
  - public 表示响应可以被任何对象缓存
  - private 表示只能被单个⽤户缓存，⾮共享的，不能被代理服务器缓存
  - no-cache 强制所有缓存了该响应的⽤户，在使⽤已缓存的数据钱，发送待验证器的请求到服务器。
  - No-store 禁⽌缓存


协商缓存

若未命中强缓存，则浏览器会将请求发送⾄服务器。服务器根据http头信息中的Last-Modify/If-ModifySince或Etag/If-None-Match来判断是否命中协商缓存。如果命中，则http返回码为304，浏览器从缓存
中加载资源。
- Last-Modify/If-Modify-Since 浏览器第⼀次请求⼀个资源的时候，服务器返回的header中会加上Last-Modify，Last-modify是⼀个时间标识该资源的最后修改时间，当浏览器再次请求该资源时，发送的请求头中会包含If-Modify-Since，该值为缓存之前返回的Last-Modify。服务器收到IfModify-Since后，根据资源的最后修改时间判断是否命中缓存。
- ETag/If-None-Match ETag可以保证每⼀个资源是唯⼀的，资源变化都会导致ETag变化。ETag值的变更则说明资源状态已经被修改。服务器根据浏览器上发送的If-None-Match值来判断是否命中缓存。

### 2.3 : 简要解释⼀下 301, 302, 304 的区别 ?

301 永久性重定向。该状态码表示请求的资源已经被分配了新的URI，并且以后使⽤资源现在所指的URI。并且根据请求的⽅法有不同的处理⽅式。

302 临时性重定向。该状态码表示请求的资源已被分配了新的URI，希望⽤户本次能使⽤新的URI访问。

304 该状态码表示客户端发送附带条件请求时，服务器端允许请求访问资源，但未满⾜条件的情况。

304状态码返回时，不包含任何响应的主题部分。附带条件的请求指的是采⽤GET⽅法的请求头中包含：If-Match、If-Modified-Since、If-None-Match、If-Range、If-Unmodified-Since中任⼀⾸部。

## JS & 算法相关

### 3.1 : 请说明以下程序打印出什么结果, 并简要说明推导依据

```js
const result = ['1', '3', '10'].map(parseInt);
// 这⾥会打印出什么呢? 
console.log( result );
```

#### 作答

打印结果是[1, NaN, 2]
因为map的参数是
```js
function(current, index, arr) { // 当前元素值，当前元素索引值，数组本身
}
```
parseInt的参数是：
```js
parseInt(str, radix) // 解析的字符串，⼏进制（若省略或为0，则以10进⾏解析，若⼩于2或者⼤于36，则返回NaN）
```
所以该题展开来写：
```js
const result = ['1', '3', '10'].map(function(cur, index, arr) {
return parseInt(cur, index);
});
// 执⾏过程：
// parseInt('1', 0) -> 1
// parseInt('3', 1) -> NaN
// parseInt('10', 2) -> 2
```

### 3.2 : 请修改以下代码, 使最后能顺序打印出 1, 2, 3, 4, 5

```js
for (var i = 0; i < 5; i++) {
  setTimeout(function () {
    console.log(i);
  }, 1000);
}
```
- 要求: 每个数字之间, 间隔时间为 1秒（提示, 好好审题哟）

#### 作答：

```js
const myPromise = num => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(num)
      }, 1000)
    })
 }

async function test() {
  for (let i = 0; i < 5;) {
    i++;
    console.log(await myPromise(i))
  }
 }
test();
```

### 3.3 : 按照如下要求实现 process ⽅法
- 取得两个数组⾥相同的部分, 并去重
- 然后按照从⼩到⼤顺序排序, 最后结果返回 (注意, 是返回结果, 不是把结果打印出来)

```js
const arrayA = [4, 2, 1, 2, 5];
const arrayB = [2, 3, 1, 6];
function process(arrayA, arrayB) {
// 这⾥是你实现代码的地⽅
}
/*
应该返回 [1, 2]
*/
process(arrayA, arrayB);
```

#### 作答部分
第一种：

```js
function process(arrayA, arrayB){
  return arrayA
    .filter((v) => arrayB.includes(v))
    .filter((v, i, arr) => arr.indexOf(v) === i )
    .sort((a, b) => a-b);
}
```

第⼆种：

```js
function process(arrayA, arrayB) {
  const set = new Set();
  while(arrayA.length > 0) {
    const ele = arrayA.pop();
    if (arrayB.includes(ele)) {
      set.add(ele);
    }
  }
  return [...set].sort((a,b) => a - b);
}
 ```

 ###  3.4 (附加题) : ⼩明要上⼀个⻓阶梯, 这个阶梯共有 N 个台阶, 假设⼩明每次能上⼀个台阶, 也能上两个台阶, 请问⼩明上这个阶梯, 总共有⼏种⾛法? 
 
 - 你的⽬标是实现⼀个⽅法
 - 输⼊是⼀个 "数字 n (有⼏个台阶)"
 - 输出是⼀个 "数字 ( 代表总共有⼏种⾛法)"

```js
/*
例如,
 n = 1, return 1 (⽅法1: 1台阶)
 n = 2, return 2 (⽅法1: 1台阶&1台阶, ⽅法2: 2台阶)
 n = 3, return 3 (⽅法1: 1台阶*3次, ⽅法2: 1台阶&2台阶, ⽅法3: 2台阶&1台阶)
*/
function step(n) {
// 这⾥是你实现代码的地⽅
}
```

#### 作答
（典型的斐波那契数列）

递归解法：

```js
function step(n) {
  if (n <= 0) {
    throw new Error("param err");
    return -1;
  }
  if (n == 1) return 1;
  if (n == 2) return 2;
  return step(n - 1) + step(n - 2);
}
 ```

⾮递归解法：

```js
function step(n) {
  if (n <= 0) {
    throw new Error("param err");
    return -1;
  }

  if (n === 1) return 1;
  if (n === 2) return 2;

  let nMinusOne = 2,
  nMinusTwo = 1,
  timeN = 0;

  for (let i = 3; i <= n; ++i) {
    timeN = nMinusOne + nMinusTwo;
    nMinusTwo = nMinusOne;
    nMinusOne = timeN;
  }
  return timeN;
}
 ```

 
综合来看，百度对前端的要求其实更看重的是解决问题的能力以及一些很基础的前段知识。面试的过程中，其实也是在复盘自己的过程，通过一次次的复盘来更加清楚自己的优劣势，明确自己的定位，这样才能在以后的工作中扬长补短，逐渐完善自己的只是体系。