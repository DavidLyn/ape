import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:ape/global/splash_page.dart';
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
import 'package:ape/rethink/writing/writing_page.dart';

import 'package:ape/social/friend_management.dart';
import 'package:ape/social/friend_setting.dart';
import 'package:ape/social/friend_adding.dart';
import 'package:ape/social/friend_ask_for.dart';
import 'package:ape/social/friend_set_relation.dart';

import 'package:ape/common/personal_home_page.dart';
import 'package:ape/common/personal_fan_page.dart';
import 'package:ape/common/personal_follow_page.dart';

/// 定义全局 Router 和初始化方法
class GlobalRouter {
  static final splash = '/';
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

  static final friendManagement = '/social/friendManagement';
  static final friendSetting = '/social/friendSetting';
  static final friendAdding = '/social/friendAdding';
  static final friendAskFor = '/social/friendAskFor';
  static final friendSetRelation = '/social/friendSetRelation';

  // 通用功能：编辑 text 字段
  static final textEdit = '/common/textEdit';

  // 通用 记录 页
  static final writing = '/common/writing';

  // 共用 个人主页/粉丝/关注
  static final personHome = '/common/personHome';
  static final personFan = '/common/personFan';
  static final personFollow = '/common/personFollow';

  static final  router = Router();

  static initRouters() {
    //找不到路由
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return Text('ERROR!!! ROUTE WAS NOT FONUND');
        }
    );

    router.define(splash, handler: Handler(handlerFunc: (_, params) {
      return SplashPage();
    }));
    router.define(home, handler: Handler(handlerFunc: (_, params) {
      return HomePage();
    }));

    router.define(login, handler: Handler(handlerFunc: (_, params) {
      return LoginPage();
    }));
    router.define(register, handler: Handler(handlerFunc: (_, params) {
      return RegisterPage();
    }));
    router.define(smsLogin, handler: Handler(handlerFunc: (_, params) {
      return SMSLoginPage();
    }));
    router.define(resetPassword, handler: Handler(handlerFunc: (_, params) {
      return ResetPasswordPage();
    }));

    router.define(message, handler: Handler(handlerFunc: (_, params) {
      return MessagePage();
    }));
    router.define(setting, handler: Handler(handlerFunc: (_, params) {
      return SettingPage();
    }));
    router.define(changeBrightness, handler: Handler(handlerFunc: (_, params) {
      return ChangeBrightnessPage();
    }));
    router.define(aboutUs, handler: Handler(handlerFunc: (_, params) {
      return AboutUsPage();
    }));
    router.define(
        personalInformation, handler: Handler(handlerFunc: (_, params) {
      return PersonalInformationPage();
    }));

    router.define(textEdit,
        handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
          var title = params['title']?.first;
          var content = params['content']?.first;
          var hintText = params['hintText']?.first;
          var maxLines = int.parse(params['maxLines']?.first);
          var maxLength = int.parse(params['maxLength']?.first);
          var keyboardType = params['keyboardType']?.first;

          return MyTextEditPage(
            title: title,
            content: content,
            hintText: hintText,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: TextInputType.text,
          );
        }));

    router.define(writing, handler: Handler(handlerFunc: (_, params) {
      return WritingPage();
    }));

    router.define(friendManagement, handler: Handler(handlerFunc: (_, params) {
      return FriendManagement();
    }));

    router.define(friendSetting,
        handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
          var uid = int.parse(params['uid']?.first);

          return FriendSetting(uid: uid);
        }));

    router.define(friendAdding, handler: Handler(handlerFunc: (_,params){return FriendAdding();}));

    router.define(friendAskFor, handler: Handler(handlerFunc: (_,Map<String, List<String>> params){
      var friendId = int.parse(params['friendId']?.first);
      var nickname = params['nickname']?.first;
      var avatar = params['avatar']?.first;
      var profile = params['profile']?.first;
      var gender = int.parse(params['gender']?.first);

      return FriendAskFor(friendId:friendId,nickname:nickname,avatar:avatar,profile:profile,gender:gender,);
    }));

    router.define(friendSetRelation, handler: Handler(handlerFunc: (_,params){return FriendSetRelation();}));

    router.define(personHome,
        handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
          var uid = int.parse(params['uid']?.first);

          return PersonalHomePage(uid: uid);
        }));

    router.define(personFan,
        handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
          var uid = int.parse(params['uid']?.first);

          return PersonalFanPage(uid: uid);
        }));

    router.define(personFollow,
        handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
          var uid = int.parse(params['uid']?.first);

          return PersonalFollowPage(uid: uid);
        }));

  }
}

/// fluro 路由跳转工具类
class NavigatorUtils {

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配(https://www.jianshu.com/p/e575787d173c)
  static push(BuildContext context, String path,
      {Map<String, String> params, bool replace = false, bool clearStack = false, TransitionType transition = TransitionType.fadeIn}) {

    var query = '';
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    //print('NavigatorUtils.push 传递的参数：$query');

    path = path + query;

    FocusScope.of(context).unfocus();
    GlobalRouter.router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: transition);
  }

  static pushWaitingResult(BuildContext context, String path, Function(Object) function,
      {Map<String, String> params, bool replace = false, bool clearStack = false, TransitionType transition = TransitionType.fadeIn}) {

    var query = '';
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    //print('NavigatorUtils.pushWaitingResult 传递的参数：$query');

    path = path + query;

    FocusScope.of(context).unfocus();
    GlobalRouter.router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: transition).then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print('NavigatorUtils.pushWaitingResult error = $error');
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

}