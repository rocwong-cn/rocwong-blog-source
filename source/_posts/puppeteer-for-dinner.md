---
title: 使用 puppeteer 为自己和团队内的小伙伴定一份可口的晚餐
tags:
  - puppeteer
categories:
  - 我爱折腾
date: 2020-06-11 15:16:13
---

## Why
疫情后来到公司被告知，以后每天的晚饭都需要自己提前一天预订了，不能像以前一样人人有份儿了。虽然不知道公司是出于什么方面考虑改成这样的，但是确实引起了很多不便。比如群里多了很多“要饭”的：

![banner](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/puppeteer/request-order.png)

当然，在某个加班的夜晚我和我的小伙伴也因为没有提前订餐导致无法吃饭，只能默默的啃着自费面包度过。。。
![banner](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/puppeteer/mantou.gif)

俗话说得好，谁痛谁劳动！作为新时代的码农一枚，在能自动化的就不手动化，能智能化就不自动化的光辉思想照耀下，就想着能不能把订餐这事儿交给程序做呢？

答案当然是：能！

## How

首先对[订餐页面](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/puppeteer/order-page.png)进行分析发现就是简单的一个`form`表单而已嘛，然后依稀记得之前团队小伙伴技术分享的时候提到过谷歌的一个通过`DevTools`协议控制`headless Chrome`的`Node`库 —— `Puppeteer`，感觉有搞头诶。

## Puppeteer

`Puppeteer`类似其他框架，通过操作`Browser`实例来操作浏览器作出相应的反应，看以下示例代码：

```js
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch(); // 启动一个浏览器，并返回browser实例
  const page = await browser.newPage(); // 新生成一个页面实例，类似Chrome中的一个tab
  await page.goto('http://rennaiqian.com'); // 页面跳转
  await page.screenshot({path: 'example.png'}); // 截图，并保存到本地
  await page.pdf({path: 'example.pdf', format: 'A4'}); // 生成PDF并保存到本地
  await browser.close(); // 自动关闭浏览器
})();
```
通过这些我们就能打开订餐页面了，但是页面表单中的数据如何输入呢？

```js
page.type('.field_2', name, {delay: 100}); 
```
可以使用`page`实例上的方法`type`来完成，`type`的三个参数定义分别为：

* 选择器，和jQuery中的选择器语法一致；
* 向输入域中赋的值；
* 一些其他选项，可空。 `delay: 100` 表示每次输入之间间隔 `100` 毫秒；

有了这些准备，接下来开搞！

## 订餐

```js
const puppeteer = require('puppeteer');
const utils = require('./utils');

/**
 * 下单
 * @param {string} name 姓名
 * @param {string} jobNo 工号
 */
async function order(name, jobNo) {
  const browser = await puppeteer.launch({headless: false});
  const page = await browser.newPage();
  await page.goto('https://xxxxxxxxx.xxxxxx/xxxxxx'); // 订餐网址
  await page.type('.field_2', name, {delay: 100}); 
  await page.type('.field_6', jobNo, {delay: 100});
  const tomorrowStr = utils.getTomorrowStr(); // 获取明天的日期
  await page.type('.ant-picker-input > input', tomorrowStr);
  await page.click('.field_5 div:nth-child(5)');
  await page.click('.published-form__footer-buttons > button');
  await page.waitForNavigation();
  const clip = await page.evaluate(() => {
    let {
        x,
        y,
        width,
        height
    } = document.querySelector('.code-info').getBoundingClientRect();
    return {
        x,
        y,
        width,
        height
    };
  });
  await page.waitFor(1000);
  const fileName = `${name}_${tomorrowStr}`;
  await page.screenshot({ path: `./screenshot/${fileName}.png`, clip });
  await page.waitFor(1000);
  browser.close();
  return fileName;
}

module.exports = {
  order,
}
```
通过上述代码即可将订餐码保存到本地，但是还是不太方便，每天都要从电脑上发送给手机，于是想到了**钉钉机器人**。

## 订餐成功通知

通过查看API发现，如果发送图片的话，一定得是图片的在线链接，怎么把本地图片转换成在线链接呢？ 买个阿里云吧！嗯！这样可以把图片传到OSS从而生成在线链接了，好在我已经有阿里云了，这样想来一下省了1000多块钱，好赚！

```js
const OSS = require('ali-oss');
const fs = require('fs');

async function uploadToOSS(fileName) {
  const client = new OSS({
    region: 'oss-cn-beijing',
    accessKeyId: 'accessKeyId',
    accessKeySecret: 'accessKeySecret',
    bucket: 'roc-auto-order',
  });
  const path = `./screenshot/${fileName}.png`;
  const result = await client.putStream(`${fileName}.png`, fs.createReadStream(path));
  return client.signatureUrl(result.name, { expires: 604800 }); //  7天
}

module.exports = {
  uploadToOSS
};
```
直接调用`ali-oss`完成图片上传并获取到图片链接，给下一步钉钉推送使用。

```js 
const request = require('request');

function pushDingding(fileName, picUrl){
  const url = 'https://oapi.dingtalk.com/robot/send?access_token=ACCESS_TOKEN';
  const data = {
    "msgtype": "markdown",
    "markdown": {
        "title":"订餐成功",
        "text": `### ${fileName} 订餐成功 \n> ![screenshot](${picUrl})\n> `
    },
     "at": {
        "isAtAll": false
     }
  };

  return new Promise(function(resolve, reject) {
    request({
      url: url,
      method: "POST",
      json: true,
      headers: {
          "content-type": "application/json",
      },
      body: data
    }, function(error, response, body) {
        if (!error && response.statusCode == 200) {
            resolve();
        }
    });
  });
};

module.exports = {
  pushDingding,
}
```

## 定时调度

经过以上操作后已经可以实现在执行的时候自动下单了，但是我想实现每天中午十二点都下单，不用我操作，怎么处理呢，以前做java的时候有定时跑批任务，nodejs应该也有的吧，去npm上找了一下发现有个`node-schedule`，非常符合需求。

```js
const schedule = require('node-schedule');
const autoOrder = require('./auto-order');
const fileUpload = require('./file-upload');
const messagePush = require('./message-push');
const config = require('./config');
const utils = require('./utils');

async function doTask() {
  for(const one of config.personList) {
    const fileName = await autoOrder.order(one.name, one.jobNo);
    const picUrl = await fileUpload.uploadToOSS(fileName);
    messagePush.pushDingding(fileName, picUrl);
  }
}

function scheduleObjectLiteralSyntax() {
  // 周一到周五的中午十二点半执行
  schedule.scheduleJob('0 30 12 * * 1-5', () => {
    utils.delDir('../screenshot');
    doTask();
  });
}

scheduleObjectLiteralSyntax();
```

## 最后

最后，使用 `pm2` 启动上面的文件即可。

## 成果

![banner](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/puppeteer/qr-code.png)