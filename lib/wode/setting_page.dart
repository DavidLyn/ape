import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart' as flutter_stars;

import 'package:ape/global/global_router.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/base_dialog.dart';
import 'package:ape/common/widget/my_selection_item.dart';

/// 设置 页面
///
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
        centerTitle: '设置',
      ),
      body: Column(
          children: <Widget>[
            SizedBox(height: 5),
            MySelectionItem(
                title: '账号管理',
                onTap: () => NavigatorUtils.push(context, '')
            ),
            MySelectionItem(
                title: '清除缓存',
                content: '23.5MB',
                onTap: () {}
            ),
            MySelectionItem(
                title: '夜间模式',
                content: themeMode,
                onTap: () => NavigatorUtils.push(context, GlobalRouter.changeBrightness)
            ),
            MySelectionItem(
                title: '关于我们',
                onTap: () => NavigatorUtils.push(context, GlobalRouter.aboutUs)
            ),
            MySelectionItem(
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
        builder: (_) => BaseDialog(
          title: '提示',
          child: const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: const Text(
                '您确定要退出登录吗？',
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          onPressed: () {
            NavigatorUtils.push(context, GlobalRouter.login, clearStack: true);
          },
        )
    );
  }

}
