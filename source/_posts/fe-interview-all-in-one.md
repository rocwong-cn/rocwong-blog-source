---
title: 从一道题目探究promise的使用技巧
tags:
  - JS
categories:
  - 学习笔记
date: 2021-03-27 17:00:33
---

如下为一段代码，请完善sum函数，使得 sum(1,2,3,4,5,6) 函数返回值为 21 ,需要在 sum 函数中调用 asyncAdd 函数进行数值运算，且不能修改asyncAdd函数

 <!-- more -->

## 题目

```js
/**
 * 请在 sum函数中调用此函数，完成数值计算
 * @param {*} a 要相加的第一个值
 * @param {*} b 要相加的第二个值
 * @param {*} callback 相加之后的回调函数
 */
function asyncAdd(a,b,callback) {
  setTimeout(function(){
   callback(null, a+b)
  },1000)
}

/**
 * 请在此方法中调用asyncAdd方法，完成数值计算
 * @param  {...any} rest 传入的参数
 */
async function sum(...rest) {
  // 请在此处完善代码
}

let start = window.performance.now()
sum(1, 2, 3, 4, 5, 6).then(res => {
  // 请保证在调用sum方法之后，返回结果21
  console.log(res)
  console.log(`程序执行共耗时: ${window.performance.now() - start}`)
})
```

本题根据程序输出时间不同,可以划分为三个难度等级

- 青铜难度， 输出时长大于6秒
- 白银难度， 输出时长大于3秒
- 王者难度， 输出时长大于1秒

## 答案

- 青铜难度

```js
async function sum(...rest) {
  // 取出来第一个作为初始值
  let result = rest.shift()
  // 通过for of 遍历 rest, 依次相加
  for(let num of rest) {
    // 使用promise 获取相加结果
    result = await new Promise(resolve => {
      asyncAdd(result, num, (_,res) => {
        resolve(res)
      })
    })
  }
  // 返回执行结果
  return result
}

// 执行成功，执行时长大于6秒
sum1(1, 2, 3, 4, 5,6).then(res => {
  console.log(`计算结果为:${res}`)
})

```

- 白银难度

在青铜难度，我们把数组里面的每一项依次相加。但是也可以进行一些优化，可以并发执行多个，比如 sum(1,2,3,4,5,6)，可以同时执行 1+2,3+4,5+6,这样就可以提升执行效率

```js
async function sum(...rest) {
  // 如果传的值少于2个，则直接返回
  if (rest.length <= 1) {
    return rest[0] || 0
  }
  const promises = []
  // 遍历将数组里面的值两个两个的执行
  for (let i = 0; i < rest.length; i += 2) {
    promises.push(
      new Promise(resolve => {
        // 如果 rest[i+1] 是 undefined, 说明数组长度是奇数，这个是最后一个
        if (rest[i + 1] === undefined) {
          resolve(rest[i])
        } else {
          // 调用asyncAdd 进行计算
          asyncAdd(rest[i], rest[i + 1], (_, result) => {
            resolve(result)
          })
        }
      })
    )
  }
  // 获取第一次计算结果
  const result = await Promise.all(promises)
  // 然后将第一次获取到的结果即 [3,7,11] 再次调用 sum执行
  return await sum(...result)
}

// 执行成功，执行时长大于3秒小于4秒
sum1(1, 2, 3, 4, 5,6).then(res => {
  console.log(`计算结果为:${res}`)
})
```

- 王者难度

```js
async function sum(...rest) {
  let result = 0
  // 隐氏类型转换， 对象 + 数字，会先调用对象的toString 方法
  const obj = {}
  obj.toString = function() {
    return result
  }
  const promises = []
  for(let num of rest) {
    promises.push(new Promise((resolve) => {
      asyncAdd(obj, num, (_, res) => {
        resolve(res)
      })
    }).then(res => {
      // 在这里将 result的值改变之后，obj.toString 的返回值就变了，这时候下一个setTimeout调用时就使用了新值
      result = res
    }))
  }
  await Promise.all(promises)
  return result
}

// 执行成功，执行时长大于1秒小于2秒
sum1(1, 2, 3, 4, 5,6).then(res => {
  console.log(`计算结果为:${res}`)
})
```

因为js是执行在单线程里面的，所以上面的代码，我们在for of将所有的计算放到promises数组里面，然后通过Promise.all去一次性执行，这时候并不需要考虑到底先执行哪两个数字相加。因为单线程的原因，我们可以保证这几个Promise是依次执行的，这时候obj.toString返回值就是上一个Promise的返回值，多跑几遍代码你就懂了。
