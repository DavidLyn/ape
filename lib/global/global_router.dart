import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:ape/global/home_page.dart';
import 'package:ape/login/login_page.dart';
import 'package:ape/login/register_page.dart';
import 'package:ape/login/sms_login_page.dart';
import 'package:ape/login/reset_password_page.dart';

import 'package:ape/wode/message_page.dart';
import 'package:ape/wode/setting_page.dart';
import 'package:ape/wode/change_brightness_page.dart';
import 'package:ape/wode/about_us_page.dart';
import 'package:ape/wode/personal_infomation_page.dart';
import 'package:ape/common/widget/my_text_edit_page.dart';

/// 定义全局 Router 和初始化方法
///
class GlobalRouter {
  static final home = '/home';
  static final login = '/login';
  static final register = '/login/register';
  static final smsLogin = '/login/smsLogin';
  static final resetPassword = '/login/resetPassword';

  static final setting = '/setting';
  static final message = '/message';
  static final changeBrightness = '/changeBrightness';
  static final aboutUs = '/aboutUs';
  static final personalInformation = '/personalInformation';

  // 通用功能：编辑 text 字段
  static final textEdit = '/common/textEdit';

  static final  router = Router();

  static initRouters() {

    //找不到路由
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context,Map<String,List<String>> params){
          print('ERROR====>ROUTE WAS NOT FONUND!!!');
          return null;
        }
    );

    router.define(home, handler: Handler(handlerFunc: (_,params){return HomePage();}));

    router.define(login, handler: Handler(handlerFunc: (_,params){return LoginPage();}));
    router.define(register, handler: Handler(handlerFunc: (_,params){return RegisterPage();}));
    router.define(smsLogin, handler: Handler(handlerFunc: (_,params){return SMSLoginPage();}));
    router.define(resetPassword, handler: Handler(handlerFunc: (_,params){return ResetPasswordPage();}));

    router.define(message, handler: Handler(handlerFunc: (_,params){return MessagePage();}));
    router.define(setting, handler: Handler(handlerFunc: (_,params){return SettingPage();}));
    router.define(changeBrightness, handler: Handler(handlerFunc: (_,params){return ChangeBrightnessPage();}));
    router.define(aboutUs, handler: Handler(handlerFunc: (_,params){return AboutUsPage();}));
    router.define(personalInformation, handler: Handler(handlerFunc: (_,params){return PersonalInformationPage();}));

    router.define(textEdit, handler: Handler(handlerFunc: (_,Map<String, List<String>> params){

      var title = params['params'][0];
      var content = params['content'][0];
      var hintText = params['hintText'][0];
      var maxLines = int.parse(params['maxLines'][0]);
      var maxLength = int.parse(params['maxLength'][0]);
      var keyboardType = params['keyboardType'][0];

      return MyTextEditPage(
        title: title,
        content: content,
        hintText: hintText,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: TextInputType.text,
      );
    }));

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