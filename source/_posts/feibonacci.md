---
title: 斐波那契数列与青蛙跳台阶
date: 2018-08-27 12:11:51
tags:
- JS
categories:
- 算法相关
---

> 定义：斐波那契数列（Fibonacci sequence），又称黄金分割数列、因数学家列昂纳多·斐波那契（Leonardoda Fibonacci）以兔子繁殖为例子而引入，故又称为“兔子数列”，指的是这样一个数列：1、1、2、3、5、8、13、21、34、…… 在数学上，斐波纳契数列以如下被以递推的方法定义：F(1)=1，F(2)=1, F(n)=F(n-1)+F(n-2)（n>=2，n∈N*）。

<!-- more -->

### 题目一：

> 写一个函数，输入n，求斐波那契（Fibonacci）数列的第n项。

* 递归解法（效率很低）：

```js
    function fibonacci_sol1(n){
        if(n < 0) return 0;
        if(n === 1) return 1;
        return fibonacci_sol1(n-1) + fibonacci_sol1(n-2);
    }
```

* 循环解法：

大概思路：首先根据f(0)和f(1)算出f(2)，再根据f(1)和f(2)算出f(3)…… 依此类推就可以算出第n项了。很容易理解，这种思路的时间复杂度是o(n)。实现代码如下：

```js
    function fibonacci_sol2(n){
        var result = [0,1];
        if(n<2){
            return result[n];
        }

        var fOne = 1,fTwo = 0,fN;
        for(var i = 2;i<=n;++i){
            fN = fOne + fTwo;

            fTwo = fOne；
            fOne = fN;
        }
        return fN;
    }
```

## 题目二：
>一只青蛙一次可以跳上1级台阶，也可以跳上2级。求该青蛙跳上一个n级的台阶总共有多少种跳法。

可以把n级台阶时的跳法看成是n的函数，记为f(n)。当n>2时，第一次跳的时候就有两种不同的选择：一是第一次只跳1级，此时跳法数目等于后面剩下的n-1级台阶的跳法数目，即为f(n-1);另一种选择是第一次跳2级，此时跳法数目等于后面剩下n-2级台阶的跳法数目，即为f(n-2)。因此，n级台阶的不同跳法的总数f(n)=f(n-1)+f(n-2)。分析到这里，不难看出这实际上就是斐波那契数列了。

与斐波那契数列不同的是，其初始值定义稍有不同， 
当n=1时，只能跳一级台阶，一种跳法 
当n=2时，一次跳一级或两级，两种跳法 
所以，关于青蛙跳台阶的定义如下：

```js
f(1) = 1;
f(2) = 2;
f(n) = f(n-1)+f(n-2),n>2;
```

* 非递归写法：

```js
    function frogJump12Step(n){
        if(n<=0){
            throw new Error("param err");  
            return -1;
        }
        if(n===1) return 1;
        if(n===2) return 2;

        var frogNMinusOne = 2;//f(n-1)=2
        var frogNMinusTwo = 1;//f(n-2)=1
        var frogN = 0;

        for (var i = 3; i <= n;++i){
            frogN = frogNMinusOne + frogNMinusTwo;
            frogNMinusTwo = frogNMinusOne;
            frogNMinusOne = frogN;
        }
        return frogN;
    }
```

* 递归解法

```js
    fcuntion frogJump12StepRecursive(int n){
        if (n <= 0){
            throw new Error("param err");  
            return -1;
        }
        if (n == 1) return 1;
        if (n == 2) return 2;
        return frogJump12StepRecursive(n - 1) + frogJump12StepRecursive(n - 2);
    }
```