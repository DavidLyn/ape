import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:ape/global/theme_provider.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/common/storage_manager.dart';
import 'package:ape/common/sqlite_manager.dart';
import 'package:ape/util/log_utils.dart';
import 'package:ape/util/file_utils.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/provider/friend_provider.dart';
import 'package:ape/provider/badge_provider.dart';
import 'package:ape/util/timeline_utils.dart';

// 初始化 provider
List<SingleChildWidget> _providers = [
  ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider(),
  ),

  ChangeNotifierProvider<FriendProvider>(
    create: (context) => FriendProvider(),
  ),

  ChangeNotifierProvider<BadgeProvider>(
    create: (context) => BadgeProvider(),
  ),
];

// 全局 context,为全局 Provider 获取 context 使用
BuildContext appContext;

void main() async {

  // 不加这句，SpUtil.getInstance()将报错
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化日志工具
  Log.init();

  // 初始化 router
  GlobalRouter.initRouters();

  // 初始化 SpUtil
  await SpUtil.getInstance();

  // 初始化 SharedPreferences、LocalStorage 等
  await StorageManager.init();

  // 初始化 database
  await DbManager.initDB();
  //await DbManager.testDB();
  //await DbManager.deleteDB();

  // 初始化 Application Documents Manager
  await ApplicationDocumentManager.init();

  // 初始化 UserInfo
  UserInfo.init();

  // 初始化 timeline
  TimelineUtils.init();

  // 不加这句好像后面的 Provider 会报错
  Provider.debugCheckInvalidValueType = null;

  runApp(MyApp());

  // Android状态栏透明 splash为白色,所以调整状态栏文字为黑色
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light));
  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return OKToast(
      child: MultiProvider(
        providers: _providers,
        child: Consumer2<ThemeProvider,FriendProvider>(
            builder: (context, themeProvider, friendProvider,child) {
              // 设置全局 context, 必须放在这儿,不然 mqtt_provider 中使用 Provider.of(conetxt) 无法正常执行
              appContext = context;

              return RefreshConfiguration(
                hideFooterWhenNotFull: true,      //列表数据不满一页,不触发加载更多
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: themeProvider.themeData(),
                  darkTheme: themeProvider.themeData(isDarkMode: true),
                  themeMode: themeProvider.getThemeMode(),
                  initialRoute: GlobalRouter.splash,     // initialRoute 只能用 '/' ???
                  onGenerateRoute: GlobalRouter.router.generator,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,   //
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    RefreshLocalizations.delegate, // pull_to_refresh 的国际化
                  ],
                  supportedLocales: [
                    const Locale('zh', 'CH'),
                    const Locale('en', 'US'),
                  ],
                  locale: Locale('zh'),
                ),
              );
            }
        )
      ),
      /// Toast 配置
      backgroundColor: Colors.black54,
      textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      radius: 20.0,
      position: ToastPosition.bottom
   );
  }
}
