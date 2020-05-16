import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:ape/global/home_page.dart';

/// 定义全局 Router 和初始化方法
///
class GlobalRouter {
  static final  router = Router();

  static initRouters() {

    //找不到路由
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context,Map<String,List<String>> params){
          print('ERROR====>ROUTE WAS NOT FONUND!!!');
          return null;
        }
    );

    router.define("/home", handler: Handler(handlerFunc: (_,params){return HomePage();}));

  }
}

/// fluro的路由跳转工具类
class NavigatorUtils {

  static push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false, TransitionType transition = TransitionType.native}) {
    FocusScope.of(context).unfocus();
    GlobalRouter.router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: transition);
  }

  static pushWaitingResult(BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false, TransitionType transition = TransitionType.native}) {
    FocusScope.of(context).unfocus();
    GlobalRouter.router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: transition).then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print('$error');
    });
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, result);
  }

  // 跳到WebView页
//  static goWebViewPage(BuildContext context, String title, String url) {
//    //fluro 不支持传中文,需转换
//    push(context, '${Routes.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
//  }

  // 参考：https://www.jianshu.com/p/e575787d173c
}