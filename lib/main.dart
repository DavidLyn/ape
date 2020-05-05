import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:ape/global/global_provider.dart';
import 'package:ape/global/theme_provider.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/global/home_page.dart';
import 'package:ape/common/storage_manager.dart';
import 'package:ape/common/sqlite_manager.dart';

// 初始化 provider
List<SingleChildWidget> _providers = [
  ChangeNotifierProvider<GlobalProvider>(
    create: (context) => GlobalProvider(),
  ),

  ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider(),
  )
];

void main() async {
  // 初始化 router
  GlobalRouter.initRouters();

  // 初始化 SharedPreferences、LocalStorage 等
  await StorageManager.init();

  // 初始化 database
  await DbManager.initDB();

  // 不加这句好像后面的 Provider 会报错
  Provider.debugCheckInvalidValueType = null;

  runApp(MyApp());

  // Android状态栏透明 splash为白色,所以调整状态栏文字为黑色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: _providers,
        child: Consumer2<GlobalProvider,ThemeProvider>(
            builder: (context, globalProvider,themeProvider, child) {
              return RefreshConfiguration(
                hideFooterWhenNotFull: true,      //列表数据不满一页,不触发加载更多
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: themeProvider.themeData(),
                  darkTheme: themeProvider.themeData(platformDarkMode: true),
                  home: HomePage(),
                  onGenerateRoute: GlobalRouter.router.generator,
                ),
              );
            }
        )
      )
   );
  }
}
