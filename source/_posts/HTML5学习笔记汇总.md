---
title: HTML5学习笔记汇总
date: 2018-05-21 20:56:20
tags:
- HTML5
categories:
- 学习笔记
---

# lesson 1 总结
[预览地址](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson1/index.html)
## 设置背景图片：

```css
background:url(pic.jpg) center center;
background-size:cover;
```
> background: #00FF00 url(bgimage.gif) no-repeat fixed top;

## transform

通过设置`translateY`的值来定位元素在Y轴的位置，如：

```css
transform:translateY(-50%);
```

<!-- more -->

## text-transform

| 值                    | 描述
| ----------------------- |:-------
| none     | 默认。定义带有小写字母和大写字母的标准的文本。      
| capitalize     | 文本中的每个单词以大写字母开头。     
| uppercase      | 定义仅有大写字母。     
| lowercase      | 定义无大写字母，仅有小写字母。    
| inherit      | 规定应该从父元素继承 text-transform 属性的值。    

## 清除默认间距

浏览器会对页面元素有默认的间距值，为了清除它们，一般做法是：
```css
html,body{
    margin: 0;
    padding: 0;
}
```
## 外部样式文件

一般的，我们会在css文件首行增加字符集设置：

```css
@charset "UTF-8";
```
## 事件拦截

通过获取到事件回调的`e`事件对象，来拦截事件响应：
```js
function onclick(e){
    e.preventDefault();
    //TODO
}
```
## 移动端适配

在`head`中增加：

```html
<meta name="viewport"
          content="width=device-width, initial-scale=1.0, shrink-to-fit=no,user-scalable=yes,maximum-scale=1.0">
```

# lesson 2 总结
[预览地址](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson2/index.html)

## manifest（离线缓存）

通过设置`html`元素的`manifest`属性来指定本地缓存配置文件，如：

```html
<html manifest="cache.manifest">
<!--something else.-->
</html>
```
在同级目录下的配置文件一般格式为：

```js
CACHE MANIFEST
/#修改时间：2018-05-11 17:55:35
CACHE:
index.css
```
* 其中，第一行为文件声明，第二行(忽略/，为了转译用)`#`后面的内容表示注释，`CACHE`后面是对需要缓存的文件的生命，其后为缓存的文件列表。如果有多个需要缓存的文件，则每一个文件路径都需要各占一行。

* 在`manifest`文件中，除`CACHE`声明哪些文件被缓存外，还有`NETWORK`和`FALLBACK`这两个关键字，分别用于声明哪些文件永远不被缓存，以及在无法建立连接的情况下显示的回退页面。此外，`CACHE`声明也可以被省略。

## link（外部链接）、meta（文档元数据）

### link

* 显示ico图标：

```html
<link rel="shortcut icon" type="image/ico" href="favicon.ico"> 
```
* 将页面添加到iOS设备主屏幕是显示的图标

```html
<link rel="apple-touch-icon-precomposed"  href="apple-touch-icon.png">
```
如果不希望iOS系统对图标添加默认的圆角和高粱效果，则可以用`apple-touch-icon-precomposed`替代`apple-touch-icon`。如下代码定义了iOS设备中默认的57 x 57及更大的72 x 72主屏图标：

```html
<link rel="apple-touch-icon-precomposed"  href="icon-57.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72"  href="icon-72.png">
```
> apple-touch-icon-precomposed按钮文件一般需指定的尺寸包括57 x 57、72 x 72、114 x 114、144 x 144、180 x 180等，并随苹果公司的产品线变化而动态变化。

* 订阅(rss+xml)

```html
<link rel="alternate" type="application/rss+xml" title="My Blog" href="rss.xml">
```

### meta

* 指定浏览器内核。

```html
<meta name="renderer" content="webkit"> 
```
`content`取值有：webkit：webkit（极速核）。ie-comp:IE兼容内核。ie-stand:IE标准内核。

此外还可以指定IE内核下优先使用最新版本引擎渲染页面，并且可以让安装了Google Chrome Frame扩展插件的浏览器激活Chrome Frame作为渲染引擎，其目的都是表面浏览器使用兼容模式，是页面尽可能以最佳方式呈现：

```html
<meta name="X-UA-Compatible" content="IE=edge,chrome=1"> 
```
* 搜索引擎优化（Search Engine Optimization,SEO)

```html
<meta name="keywords" content="HTML5,前端，代码，样式"> 
<meta name="description" content="这是一个HTML5开发的前端页面"> 
```

* 移动端浏览器处理
不希望页面中的数字自动识别为电话号码，从而显示为拨号的超链接：

```html
<meta name="format-detection" content="telephone=no"> 
```
`content`还有email=no等取值

# lesson 3 总结
[DEMO预览地址](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson3/index.html)

## line-height（行高）

与大多数CSS属性不同，line-height支持属性值设置为无单位的数字。有无单位在子元素继承属性时有微妙的不同。
* 语法

line-height: normal | <number> | <length> | <percentage>
normal 根据浏览器决定，一般为1.2。
number 仅指定数字时（无单位），实际行距为字号乘以该数字得出的结果。可以理解为一个系数，子元素仅继承该系数，子元素的真正行距是分别与自身元素字号相乘的计算结果。大多数情况下推荐使用，可以避免一些意外的继承问题。length 具体的长度，如px/em等。
percentage 百分比，100%与1em相同。

* 有单位（包括百分比）与无单位之间的区别
有单位时，子元素继承了父元素计算得出的行距；无单位时继承了系数，子元素会分别计算各自行距（推荐使用）。

由此可以得出demo页面的三种计算方式：
* 百分比：父元素的行高为150%时，会根据父元素的字体大小先计算出行高值然后再让子元素继承。所以当line-height:150%时，字元素的行高等于16px * 150% = 24px
* em：父元素的行高为1.5em时，会根据父元素的字体大小先计算出行高值然后再让子元素继承。所以当line-height:1.5em时，子元素的行高等于16px * 1.5em = 24px
* 无单位：父元素行高为1.5时，会根据子元素的字体大小动态计算出行高值让子元素继承。所以，当line-height:1.5时，子元素行高等于30px * 1.5 = 45px

总的来说，当父元素行高为百分比和em时，会根据父元素的字体大小先计算出行高值然后再让子元素继承。当父元素行高为无单位情况下，会根据子元素的字体大小动态计算出行高值让子元素继承。

参考地址：[CSS:line-height:150%与line-height:1.5的真正区别是什么？](https://www.zhihu.com/question/20394889)

## float (浮动)

由于浮动的设置，两个块级元素不在各占一行，而是在同一行中一起显示。如果希望两个仍各占一行，则可以用clear属性来清楚浮动。其中设置该属性的值为`both`时，表示在元素的左右两侧均不允许浮动元素。

```css
*{
    clear:both;
}
```
具体请通过预览DEMO来观察。

## text-shadow、box-shadow

```css
text-shadow:x y deg color;
box-shadow:x y deg speed color inset/outset;
```

## 样式优先级 由低到高

* 通用选择器。如`*{...}`
* 标签选择器。如`h1{...}`
* 类选择器。如`.nav{...}`
* 伪类选择器。如`a:hover{...} 、 li:first-child{...}`
* ID选择器。如`#title{...}`
* 行间样式。如`<div style = "color:red;"></div>`


# lesson 4 总结
[DEMO预览地址](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson4/index.html)

> 终于迎来了我喜欢的 javascript 环节了呢，嘻嘻~

## console

```js
console.log(msg); //正常显示
console.error(msg); //淡红底色并带有错误标志
console.info(msg);// 正常
console.debug(msg);// 调试信息
console.warn(msg);// 淡黄色底色并带有警告标志
```

`tip:` 在Console窗口中要为代码换行时，可以使用Shift+Enter组合键。

## function

* 立即执行函数 (IIFE: Immediately Invoked Function Expression)

如果定义了一个匿名函数且没有将其赋予某个变量，要执行这个匿名函数，则可以采用`(function(){})()`的代码格式。其中前一个括号里面是匿名的函数，后一个括号中是传入的参数，如果没有参数则括号中的内容可以为空，代码如下：

```js
(function(name){
    console.log('My name is '+name);
})('Roc') //输出 My name is Roc
```
当然，也有其他写法，如：

```js
(function(name){
    console.log('My name is '+name);
}('Roc')) //输出 My name is Roc
```
和

```js
!function(name){
    console.log('My name is '+name);
}('Roc') //输出 My name is Roc
```
简单来说，`IIFE`的作用在于使得函数在被载入时自动执行，同时利用匿名函数和闭包的特性形成一个独立的作用域，将内部所有的变量封闭起来，使其不会影响到函数外部的其他变量。

## cancelBubble 和 stopPropagation

> 可以参考DEMO中的应用来理解

事实上`stopPropagation`和`cancelBubble`的作用是一样的，都是用来阻止浏览器默认的事件冒泡行为。
不同之处在于`stopPropagation`属于W3C标准，试用于Firefox等浏览器，但是不支持IE浏览器。相反`cancelBubble`不符合W3C标准，而且只支持IE浏览器。所以很多时候，我们都要结合起来用。不过，`cancelBubble`在新版本chrome,opera浏览器中已经支持。
所以，一般我们都写作：

```js
    elem.onclick = function(e){
         window.event ? e.cancelBubble = true : e.stopPropagation();
    }
```
另外，`jquery`的`stopPropagation()`已经做了兼容性处理：

```js
jQuery.Event.prototype = {
    stopPropagation: function() {
        this.isPropagationStopped = returnTrue;

        var e = this.originalEvent;
        if ( !e ) {
            return;
        }
        // if stopPropagation exists run it on the original event
        if ( e.stopPropagation ) {
            e.stopPropagation();
        }
        // otherwise set the cancelBubble property of the original event to true (IE)
        e.cancelBubble = true;
    }
}
```

参考网址：[Event.cancelBubble - Web APIs | MDN](https://developer.mozilla.org/en-US/docs/Web/API/Event/cancelBubble)

# lesson 5 总结
[DEMO预览地址](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson5/index.html)

## viewport

viewport 翻译为中文可以叫做"视区"。
手机浏览器是把页面放在一个虚拟的"窗口"（viewport）中，通常这个虚拟的"窗口"（viewport）比屏幕宽，这样就不用把每个网页挤到很小的窗口中（这样会破坏没有针对手机浏览器优化的网页的布局），用户可以通过平移和缩放来看网页的不同部分。

一个常用的 viewport meta 如下：

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```
* width：控制 viewport 的大小，可以指定的一个值，如 600，或者特殊的值，如 device-width 为设备的宽度（单位为缩放为 100% 时的 CSS 的像素）。
* height：和 width 相对应，指定高度。
* initial-scale：初始缩放比例，也即是当页面第一次 load 的时候缩放比例。
* maximum-scale：允许用户缩放到的最大比例。
* minimum-scale：允许用户缩放到的最小比例。
* user-scalable：用户是否可以手动缩放。

## vw vh

vw	相对于视窗(viewport)的宽度：视窗宽度是100vw
vh	相对于视窗(viewport)的高度：视窗高度是100vh
vmin 和 vmax 自动选择相对于`viewport`宽高而言最小或者最大的制

* 换算：5vw = 屏幕宽度的1/20，即为5%，当屏幕宽度为400px时，字体大小为20px；

## 弹性布局

* 为父元素增加display

```css
display:flex;
display:-webkit-flex;  /* webkit内核浏览器的兼容写法 */
```
* flex-direction
取值有：

```html
row            横向布局 默认取值
column         纵向布局
column-reverse 纵向反向排列
```
* flex

```css
flex : 1 1 auto;
-webkit : 1 1 auto;
```
flex属性的三个参数分别为：
  flex-grow : 决定伸缩元素可扩展空间的分配，在此为1，表示每个元素的可扩展空间大小相等；
  flex-shrink : 定义当元素超过容器的大小后的压缩比例，在此为1，即每隔元素的亚索能力相同；
  flex-basis : 定义伸缩的基准值，在此为`auto`，即自动分配空间。
  
## CSS Sprite 雪碧图 

> CSS雪碧的基本原理是把你的网站上用到的一些图片整合到一张单独的图片中，从而减少你的网站的HTTP请求数量。该图片使用CSS background和background-position属性渲染，这也就意味着你的标签变得更加复杂了，图片是在CSS中定义，而非<img>标签。

```css
a {
    display:block; width:200px; height:65px; line-height:65px; /*定义状态*/
    text-indent:-2015px; /*隐藏文字*/
    background-image:url(button.png); /*定义背景图片*/
    background-position:0 0; /*定义链接的普通状态，此时图像显示的是顶上的部分*/
   }
a:hover {background-position:0 -66px; /*定义链接的滑过状态，此时显示的为中间部分，向下取负值*/}
a:active {background-position:0 -132px; /*定义链接的普通状态，此时显示的是底部的部分，向下取负值*/}
```
## Icon Font 图标字体

自定义字体：

```css
@font-face {
font-family: 'roc-font';
src:url('roc-iconfont.ttf'),url('roc-iconfont.eot'),url('roc-iconfont.woff');
}
```
实际使用：

```css
h1:before{
    font-family: 'roc-font';
    content:'\e626'; /* 来自于自定义字体的unicode编码 */
}
```

## 一些移动端开发技巧

* 当用户在iOS设备中按住一个页面元素时，iOS会自动在元素周围显示橙色的外框，表示钙元素被按中，这一高亮效果可以用下面代码去除

```css
*{
    -webkit-tap-highlight-color: rgba(0,0,0,0); /* 设为透明 */
}
```
以上代码还可以解决在一些Android机型中，单击后发生被绑定单击区域闪一下的问题。

* 以下代码可以避免在横竖屏幕切换时，移动设备对页面的文字大小进行自动调整：

```css
html{
    -webkit-text-size-adjust: 100%;
    -ms-text-size-adjust: 100%;
    text-size-adjust: 100%;
}
```

* 当页面高度设置为100%是，去除系统自带的导航栏高度的方法：

```js
document.documentElement.style.height = window.innerHeight + 'px';
```

* 获取用户设备类型

```js
console.log(navigator.userAgent)
```

* 获取设备的网络连接类型, ethernet, wifi,2G,3G,4G ...

```js
navigator.connection.type
```

* 获取设备的横竖屏状态

```js
window.orientation || screen.orientation
```

* 用户在使用iOS设备从主屏幕直接启动某个页面时，显示一副启动图：

```html
<link rel="apple-touch-startup-image" href="default.png" /> 
```
* 当站点有配套的Apple Store APP时，可以通过添加名为`Smart App Banners` 的 meta 标签，将应用链接（下载条幅）显示在页面顶部，方便用户下载使用

```html
<meta name="apple-itunes-app" content="app-idd=547523434" />
```

# lesson 6 总结

> 本节课主要学习是布局相关知识。

[两列均分布局](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson6/index.html)
| [格子布局](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson6/grid.html)
| [格子布局 - 跨行](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson6/grid1.html)


## 清除浮动

```css
section::after{
    content: '';
    display:table;
    clear:both;
}
```
但是老版本IE并不支持`::after`伪元素，可以采用手动插入一段DOM结构的方式来清除浮动。
一般的，一个常用的清除浮动的类就可以写作：

```css
.clearfix:before, .clearfix:after{
    content:'';
    display: table;
}
.clearfix:after{
    clear:both;
}
```
使用时：

```html
<section class="clearfix">...</section>
```
需要补充说明的是，将`display`属性设置为`table`，并设置`clear`为`both`，是为了使清除浮动的时候形成一种名为`BFC（Block Format Content, 块级格式化上下文）` 的机制。在`BFC`中，元素布局不收外界的影响，我们往往利用该特性来清除浮动元素对其他非浮动元素带来的影响。
此外，在`BFC`中，块级元素与由行内元素组成的"行盒子"会垂直的沿其父元素的边框排列。触发`BFC`的因素很多，如上述设置`display`为`table`即为其中的一种因素（也可以设置`display`为`inline-block`、`table-cell`、`table-caption`、`flex`、`inline-flex`等）。
而且，`overflow`不为`visible`也会触发`BFC`。

[overflow触发BFC的Demo](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson6/bfc.html)

## box-shadow 设置框线

为元素顶部绘制一条1像素宽，颜色为40%透明度黑色的边框：

```css
box-shadow:0 0 1px rgba(0,0,0,.4) inset;
```

## 布局总结：

如Demo中所体现出来的，无论什么布局都可以使用百分比布局来实现：

* 规定其父元素的固定宽度（或者最小宽度）；
* 设置其子元素的宽度为对应的百分比（如两列均等布局，宽度分别为50%）；
* 设置子元素的float(浮动)；
* 为了防止高度"坍塌"，清除父元素浮动。

# lesson 7 总结
[两列自适应布局](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson7/index.html)
 | [三列自适应布局（圣杯布局）](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson7/three-col.html)
 | [三列自适应布局（淘宝UED - 双飞翼布局）](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson7/two-wings.html)
 | [瀑布流布局）](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson7/waterfall.html)


本节课主要学习了高阶布局相关的知识，并深入理解了`relative`（相对布局）和`absolute`（绝对布局）

参考网址：[css-相对绝对定位系列（一） —— 张鑫旭的博客](http://www.zhangxinxu.com/wordpress/2010/12/css-%E7%9B%B8%E5%AF%B9%E7%BB%9D%E5%AF%B9%E5%AE%9A%E4%BD%8D%E7%B3%BB%E5%88%97%EF%BC%88%E4%B8%80%EF%BC%89/)


# lesson 8 总结
[transition demo](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson8/index.html)
 | [animation demo1 - 会旋转的图标](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson8/animation.html)
 | [animation demo2 - 会移动的一排图标](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson8/animation2.html)
 | [animation demo3 - cubic bezier](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson8/animation3.html)

> 动画与特效

## transition

`transition` 属性是一个简写属性，用于设置四个过渡属性：

* transition-property
* transition-duration
* transition-timing-function
* transition-delay

**注释**：请始终设置 transition-duration 属性，否则时长为 0，就不会产生过渡效果。

**默认值：** `all 0 ease 0`

| 值                 | 描述
| -------------------|:--------
| transition-property | 规定设置过渡效果的 CSS 属性的名称。
| transition-duration | 规定完成过渡效果需要多少秒或毫秒。
| transition-timing-function | 规定速度效果的速度曲线。默认 `ease`
| transition-delay | 定义过渡效果何时开始。

属性取值：

* transition-property : `all` `none` 或者其他的属性值，如：`width` `background` 等
* transition-duration : `0.5s` `5000ms`
* transition-timing-function : `ease` `linear` `ease-in` `ease-out` `ease-in-out`
* transition-delay `0s`

一般用法：

```css
 transition: all 0.5s;

 transition: color 0.5s linear;
```

组合用法：

```css
  transition: color 0.5s linear, background .5s ease-in-out 1s;
```

## animation

`animation` 属性是一个简写属性，用于设置六个动画属性：

| 值                 | 描述
| -------------------|:--------
| animation-name | 规定需要绑定到选择器的 keyframe 名称。
| animation-duration | 规定完成动画所花费的时间，以秒或毫秒计。
| animation-timing-function | 规定动画的速度曲线。默认 `ease`
| animation-delay | 规定在动画开始之前的延迟。
| animation-iteration-count | 规定动画应该播放的次数。
| animation-direction | 规定是否应该轮流反向播放动画。

**注释**：请始终规定 animation-duration 属性，否则时长为 0，就不会播放动画了。

## animation-fill-mode

`animation-fill-mode` 属性规定动画在播放之前或之后，其动画效果是否可见。
**注释**：其属性值是由逗号分隔的一个或多个填充模式关键词。

语法:

```css
animation-fill-mode : none | forwards | backwards | both;
```

| 值                 | 描述
| -------------------|:--------
| none | 不改变默认行为。
| forwards | 当动画完成后，保持最后一个属性值（在最后一个关键帧中定义）。
| backwards | 在 animation-delay 所指定的一段时间内，在动画显示之前，应用开始属性值（在第一个关键帧中定义）。
| both | 向前和向后填充模式都被应用。

参考网址：

[理解animation-fill-mode属性](https://www.w3cplus.com/css3/understanding-css-animation-fill-mode-property.html)
[如何理解animation-fill-mode及其使用？](https://segmentfault.com/q/1010000003867335)

## 为动画添加 cubic-bezier （三次贝塞尔）函数

通过 [cubic-bezier](http://cubic-bezier.com) 网站来生成三次贝塞尔曲线函数，然后添加到`animation`后：

```css
.icon{
    animation: move 1s cubic-bezier(.51,-1.09,.39,1.89);
    -webkit-animation: move 1s cubic-bezier(.51,-1.09,.39,1.89);
}
```


# lesson 9 总结

* 页面切换动效

[横向平移特效](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/index.html)
 | [纵向平移特效](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/index2.html)
 | [缩小放大特效](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/index3.html)
 | [水平翻转特效](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/index4.html)
 | [翻转加缩放](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/index5.html)

* Loading 动效

[简单loading](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/loading.html)
 | [带有拖尾效果的loading](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/loading2.html)
 | [横向 dot loading ](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/loading-dot.html)
 | [circle dot loading ](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/loading-round.html)
 
 * 翻书动效

 | [book paging](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson9/book.html)

## Meta http-equiv属性

http-equiv顾名思义，相当于http的文件头作用，它可以向浏览器传回一些有用的信息，以帮助正确和精确地显示网页内容，与之对应的属性值为content，content中的内容其实就是各个参数的变量值。

> meat标签的http-equiv属性语法格式是：＜meta http-equiv="参数" content="参数变量值"＞

```html
<meta http-equiv="Page-Enter" content="revealTrans(duration=1.0,transtion=12)">
<meta http-equiv="Page-Exit"  contect="revealTrans(duration=1.0,transtion=12)">   
```

Duration的值为网页动态过渡的时间，单位为秒。  
Transition是过渡方式，它的值为0到23，分别对应24种过渡方式。如下表：

```text
0  盒状收缩            1  盒状放射  
2  圆形收缩            3  圆形放射  
4  由下往上            5  由上往下  
6  从左至右            7  从右至左  
8  垂直百叶窗          9  水平百叶窗  
10 水平格状百叶窗       11 垂直格状百叶窗  
12 随意溶解            13 从左右两端向中间展开  
14 从中间向左右两端展开  15 从上下两端向中间展开  
16 从中间向上下两端展开  17 从右上角向左下角展开  
18 从右下角向左上角展开  19 从左上角向右下角展开  
20 从左下角向右上角展开  21 水平线状展开  
22 垂直线状展开         23 随机产生一种过渡方式  
```
## CSS3 perspective 属性

* 浏览器支持

目前浏览器都**不**支持 `perspective` 属性。
Chrome 和 Safari 支持替代的 `-webkit-perspective` 属性。

* 定义和用法

perspective 属性定义 3D 元素距视图的距离，以像素计。该属性允许您改变 3D 元素查看 3D 元素的视图。
当为元素定义 perspective 属性时，其子元素会获得透视效果，而不是元素本身。

**注释**：perspective 属性只影响 3D 转换元素。

```css
perspective: number|none;
```

## CSS3 backface-visibility 属性

`backface-visibility` 属性定义当元素不面向屏幕时是否可见。
如果在旋转元素不希望看到其背面时，该属性很有用。

```css
backface-visibility: visible|hidden;
```

## before 与 after 伪元素

**一个小知识点：after伪元素默认的显示层级高于before伪元素。**

## transform-origin

transform-origin 属性允许您改变被转换元素的位置。
2D 转换元素能够改变元素 x 和 y 轴。3D 转换元素还能改变其 Z 轴。

```css
transform-origin: x-axis y-axis z-axis;
```
参考网址：[CSS3 transform-origin 属性](http://www.w3school.com.cn/cssref/pr_transform-origin.asp)


# lesson 10 总结
[DEMO预览地址](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson10/index.html)


## canvas

canvas本身没有绘图能力，需要通过它的`getContext()`方法来返回可绘图的对象。

清除画布区域：

```js
context.clearRect(0,0,window.innerWidth,window.innerHeight);
```
Canvas中的`arc()`方法可用于创建原型形状，它的几个参分别代表圆心的x坐标、y坐标、半径、起始角度和结束角度。其中角度的单位是"弧度"而非"角度"，因此要绘制一个完整的原型，其起始角度为0，结束角度应为2π。

```js
context.arc(100, 100, 5, 0, Math.PI * 2);
```

## 随机颜色

```js
'#'+('000000'+(Math.random()*0x1000000<<0).toString(16)).slice(-6)
```

## GSAP

[带缩略效果的飞机](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson10/gsap.html)
[会旋转的飞机](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson10/example2.html)
[矩形变圆形](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson10/example3.html)
[盒子横向展开效果](http://htmlpreview.github.io/?https://github.com/rocwong-cn/html5-learning/blob/master/lesson10/example4.html)

更多介绍见Github:[GreenSock-JS](https://github.com/greensock/GreenSock-JS)