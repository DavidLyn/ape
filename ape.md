---
# 程序结构和命名规范

## 程序结构

> global ：全局用组件
>
> common ：公用组件，可能为各个模块使用的组件
>
> entity ：实体类
>
> base ：基础组件，一些基类
>
> util ：工具类组件
>
> login ：注册类组件
>
> 其他业务类组件 ：每类业务设置一个 package

## 组件命名规范

> provider : XyzProvider
> 
> page : XyzPage

## 文件命名规范

> xxx_provider.dart : provide 文件
>
> xxx_entity.dart : 实体对象文件
> 
> xxx_page.dart : 页面文件

---
# 资源文件结构

> /assets/images/common 下放置框架类图片，正常每个应用不会改变
>
> /assets/images/splash splash 图片

---
# 公用组件和包

## /lib/util/log_utils.dart

> 日志工具类，用于输出日志

## lib/util/device_info_utils.dart

> 设备信息工具，用于判断当前设备类型

## /common/widget/loaded_image_widgets.dart

> 从本地资源或url获取的 image 组件

## /lib/util/theme_utils.dart

> 定义常用颜色以及从当前主题中获取特定颜色

---
# 需要根据业务需求个性化的模块

## common/constants.dart

+ SpConstants

> Shared Preference 中用到的 key name 以静态方式在本类中声明，并被引用

## global/global_router.dart

+ GlobalRouter

> 所有页面的 router 以静态方式在本类中声明，并被引用

## network/nm_api.dart

+ NWApi

> base url 和所有 Rest 接口 url 以静态方式在本类中声明，并被引用

---
# 踩坑记录

## 在虚拟机中不能使用 127.0.0.1 或 localhost 访问本机，应使用本机的 ip 地址

