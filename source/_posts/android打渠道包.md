---
title: android打渠道包
date: 2016-12-10 20:35:03
tags:
- 
categories:
- android
---

首先需要在android/app/build.gradle裡面添加一下命令：

<!-- more -->

{% blockquote app/build.gradle %}
   productFlavors {多渠道打包
               android {}安卓市场
               c360 {}360市场
               xiaomi {}小米市场
               yingyongbao {}应用宝
               flyme {}魅族flyme市场
               wandoujia {}豌豆荚
               anzhi {}安智市场
               lenovo {}联想
               huawei {}华为
               yingyonghui {}应用汇
               jifeng {}机锋市场
               sougou {}搜狗市场
               oppo {}oppo市场
               uc {}UC商店/PP助手/淘宝助手
               pp {}PP助手
               mumayi {}木蚂蚁
               vivo {}vivo
               jinli {}金立
               souhu {}搜狐
               baidu {}百度市场
               productFlavors.all { flavor ->
                   flavor.manifestPlaceholders = [APP_CHANNEL: name]
               }
           }
   {% endblockquote %}
   
   如果用到了友盟等統計插件的話，然後删除manifestPlaceholders里面的APP_CHANNEL,AndroidManifest.xml里面添加：
     {% codeblock %}
         <meta-data android:value="${APP_CHANNEL}"  android:name="UMENG_CHANNEL"/>
     {% endcodeblock %}
