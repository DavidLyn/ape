import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:ape/global/home_page.dart';

/// 定义全局 Router 和初始化方法
///
class GlobalRouter {
  static final  router = Router();

  static initRouters() {

    router.define("home", handler: Handler(handlerFunc: (_,params){return HomePage();}));

  }
}