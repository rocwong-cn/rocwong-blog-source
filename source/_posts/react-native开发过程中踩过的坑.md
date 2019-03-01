---
title: react-native开发过程中踩过的坑
date: 2017-08-07 09:50:23
tags:
- 踩坑之旅
categories:
- React-Native
---
# 0、Could not install the app on the device, read the error above for details.

<!-- more -->

```$xslt
jax$  react-native run-android
Starting JS server...
Building and installing the app on the device (cd android && ./gradlew installDebug...

Could not install the app on the device, read the error above for details.
Make sure you have an Android emulator running or a device connected and have
set up your Android development environment:
https://facebook.github.io/react-native/docs/android-setup.html

jax$ adb devices
List of devices attached
192.168.56.101:5555 device
```
解决方案：
首先，你应该检查你android/gradlew的权限，应该是755而不是644，然后在你的根目录执行：
{% codeblock %}
chmod 755 android/gradlew
{% endcodeblock %}

# 1、当把RN项目从一个目录移动到另一个目录时，run-ios时可能会出现异常：
```$xslt
error: PCH was compiled with module cache path 
```
解决方案：在项目根目录下执行
```$xslt
rm -rf ios/build/ModuleCache/*
```
然后再react-native run-ios,搞定。

# 2、当react-native unlink xxxx某些模块是，会出现search.filter not a function的异常，
解决方案：
找到ios/项目名.xcodeproj/project.pbxproj，并用webstorm等非xocde编译器打开，然后全局搜索**"$(inherited)"**，
将其替换成("$(inherited)")。注意：是当前search path下只存在"$(inherited)"一个的情况下。

# 3、RN版本0.45以后经常会出现一些third-party的问题，比如：third-party: 'config.h' file not found

解决方案：
* 在项目根目录下执行：（不一定是这个路径，具体看third-party下的glog版本）
```$xslt
cd node_modules/react-native/third-party/glog-0.3.4
```
* 执行
```$xslt
../../scripts/ios-configure-glog.sh
```
* Glog配置完成，xcode也会找到*config.h*头文件了。