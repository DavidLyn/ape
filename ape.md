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

## 添加 反思-写作 writing（音频-audio、视频-video） 页面


---
# 踩坑记录

## 在虚拟机中不能使用 127.0.0.1 或 localhost 访问本机，应使用本机的 ip 地址

## android api 26 时，MyAppBar 上的点击事件不起作用！！！

## 国际化及 showDatePicker 显示中文

### 配置flutter_localizations依赖

```
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
```

### 在 main.dart 中导入国际化包

```
import 'package:flutter_localizations/flutter_localizations.dart';
```

### 设置国际化

```
void main() {
  runApp(
    new MaterialApp(
      title: 'app',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new MyLoginWidget(),
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
    ),
  );
}
```

### 控件的中文设置

```
_showDatePicker() async{
    var date =await showDatePicker(
      context: context,
      initialDate: _datetime,
      firstDate:DateTime(1900),
      lastDate:DateTime(2050),
      locale: Locale('zh'),    
    );
    if(date==null) return;
    print(date);
    setState(() {
       _datetime=date;
    });
}
```
---
# Android 调试
## 打包生成 APK
### 生成密钥文件

> 创建目录 /Users/lvweiwei/ViviProj/gorilla/apekey
> 
> 各种密码：123456

```
keytool -genkey -v -keystore ape.jks -keyalg RSA -keysize 2048 -validity 10000 -alias ape
```

```
输入密钥库口令:  123456
再次输入新口令:  123456
您的名字与姓氏是什么?
  [Unknown]:  lvvv
您的组织单位名称是什么?
  [Unknown]:  vivi
您的组织名称是什么?
  [Unknown]:  vivi
您所在的城市或区域名称是什么?
  [Unknown]:  beijing
您所在的省/市/自治区名称是什么?
  [Unknown]:  beijing
该单位的双字母国家/地区代码是什么?
  [Unknown]:  cn
CN=lvvv, OU=vivi, O=vivi, L=beijing, ST=beijing, C=cn是否正确?
  [否]:  y

```

### 修改 /android/app/build.gradle 文件

> 按注释修改

```
android {
    compileSdkVersion 28

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    lintOptions {
        disable 'InvalidPackage'
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.lvlv.gorilla.ape"
        minSdkVersion 16
        targetSdkVersion 28
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    /*针对打包新加的 -- start*/
    signingConfigs {
        release {
//            keyAlias keystoreProperties['keyAlias']
//            keyPassword keystoreProperties['keyPassword']
//            storeFile file(keystoreProperties['storeFile'])
//            storePassword keystoreProperties['storePassword']
            keyAlias "ape"
            keyPassword "123456"
            storeFile file("/Users/lvweiwei/ViviProj/gorilla/apekey/ape.jks")
            storePassword "123456"
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
    /*针对打包新加的 -- end */

    // 原有内容被注释
//    buildTypes {
//        release {
//            // TODO: Add your own signing config for the release build.
//            // Signing with the debug keys for now, so `flutter run --release` works.
//            signingConfig signingConfigs.debug
//        }
//    }
}
```

### 设置网络权限

修改 `android\app\src\main\AndroidManifest.xml` 在 `</manifest> `前面加上代码：

```
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```

### 打包生成 APK

> 直接在 Android Studio 的 Terinal 执行命令

```
flutter build apk
```

**生成的 apk 位置：当前项目\build\app\outputs\apk\release\xx.apk**

### 错误处理

+ 出现 **Execution failed for task ':keyboard_visibility:verifyReleaseResources'.**，将插件 **keyboard_visibility** 的 **build.gradle** 的 

```
compileSdkVersion 27
```

修改为：

```
compileSdkVersion 28
```

+ 出现 **Task 'assembleAarRelease' not found in root project 'flutter_plugin_android_lifecycle'.**

在 pubspec.yaml 中添加：

```
  flutter_plugin_android_lifecycle: ^1.0.9
```

### 参考

[flutter打包Android的apk](https://blog.csdn.net/weixin_42912237/article/details/90258414)

[Flutter打包apk中的一些巨坑](https://blog.csdn.net/weixin_30415801/article/details/99567010)

## adb 的使用

+ adb devices - 列出设备

+ adb shell - 进入设备的 shell 界面

+ 在设备安装 apk

```
adb install 安装包的地址  #默认安装
adb install -r  "安装包的地址"         #覆盖安装（已安装了）
```

---
# ios 调试
## 设置权限

在 ```<project root>/ios/Runner/Info.plist``` 中：

```
<key>NSPhotoLibraryUsageDescription</key>
<string>需要您的同意,APP才能访问相册</string>

<key>NSCameraUsageDescription</key>
<string>需要您的同意,APP才能访问相机</string>

<key>NSMicrophoneUsageDescription</key>
<string>需要您的同意,APP才能访问麦克风</string>

<key>NSLocationUsageDescription</key>
<string>需要您的同意, APP才能访问位置</string>
```

**详细参见：[iOS info.plist访问权限设置](https://blog.csdn.net/qq_16696763/article/details/88863057)**
