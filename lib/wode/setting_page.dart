import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart' as flutter_stars;

import 'package:ape/global/global_router.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_selection_item.dart';
import 'package:ape/mqtt/mqtt_provider.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/network/rest_result_wrapper.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/util/other_utils.dart';
import 'package:ape/util/log_utils.dart';

/// 设置 页面
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var theme = flutter_stars.SpUtil.getString(SpConstants.appTheme);
    var themeMode;
    switch(theme) {
      case 'Dark':
        themeMode = '开启';
        break;
      case 'Light':
        themeMode = '关闭';
        break;
      default:
        themeMode = '跟随系统';
        break;
    }

    return Scaffold(
      appBar: const MyAppBar(
        backgroundColor: Colors.green,
        centerTitle: '设置',
      ),
      body: Column(
          children: <Widget>[
            SizedBox(height: 5),
            MySelectionItem(
                icon: Icon(Icons.add_circle, color: Colors.green,),
                title: '个人信息',
                onTap: () => NavigatorUtils.push(context, GlobalRouter.personalInformation)
            ),
            MySelectionItem(
                icon: Icon(Icons.adb, color: Colors.green,),
                title: '吾友',
                onTap: () => NavigatorUtils.push(context, GlobalRouter.friendManagement)
            ),
            MySelectionItem(
                icon: Icon(Icons.announcement, color: Colors.green,),
                title: '清除缓存',
                content: '23.5MB',
                onTap: () {}
            ),
            MySelectionItem(
                icon: Icon(Icons.android, color: Colors.green,),
                title: '夜间模式',
                content: themeMode,
                onTap: () => NavigatorUtils.push(context, GlobalRouter.changeBrightness)
            ),
            MySelectionItem(
                icon: Icon(Icons.account_box, color: Colors.green,),
                title: '关于猩猩',
                onTap: () => NavigatorUtils.push(context, GlobalRouter.aboutUs)
            ),
            MySelectionItem(
              icon: Icon(Icons.airplay, color: Colors.green,),
              title: '退出当前账号',
              onTap: () => _showExitDialog(),
            ),
          ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('您确定要退出登录吗？'),
            actions: <Widget>[
              FlatButton(child: Text('取消'),onPressed: (){
                Navigator.pop(context);
              },),
              FlatButton(child: Text('确认'),onPressed: (){
                // 设置 未登录 标志
                flutter_stars.SpUtil.putBool(SpConstants.isNotLogin, true);

                // 关闭 mqtt
                MQTTProvider.disconnect();

                // 通知后台退出登录
                DioManager().request<String>(
                    NWMethod.GET,
                    NWApi.logout,
                    params: <String,dynamic>{'uid':UserInfo.user.uid},
                    success: (data,message) {
                      Log.d("Logout success!");
                    },
                    error: (error) {
                      Log.e("Logout error! code = ${error.code}, message = ${error.message}");

                      OtherUtils.showToastMessage('退出登录失败 : ${error.code}!');
                    }
                );

                NavigatorUtils.push(context, GlobalRouter.splash, clearStack: true);
              },),
            ],
          );
        },
    );
  }

}
