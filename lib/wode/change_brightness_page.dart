import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flustars/flustars.dart' as flutter_stars;
import 'package:ape/common/constants.dart';
import 'package:ape/global/theme_provider.dart';
import 'package:ape/common/widget/my_app_bar.dart';

/// 更改 亮度模式 页面
class ChangeBrightnessPage extends StatefulWidget {
  @override
  _ChangeBrightnessPageState createState() => _ChangeBrightnessPageState();
}

class _ChangeBrightnessPageState extends State<ChangeBrightnessPage> {

  var _list = ['跟随系统', '开启', '关闭'];

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
        backgroundColor: Colors.green,
        centerTitle: '夜间模式',
      ),
      body: ListView.separated(
          shrinkWrap: true,
          itemCount: _list.length,
          separatorBuilder: (_, index) {
            return const Divider();
          },
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                ThemeMode themeMode = index == 0 ? ThemeMode.system : (index == 1 ? ThemeMode.dark : ThemeMode.light);
                Provider.of<ThemeProvider>(context, listen: false).setTheme(themeMode);

//                _subscription?.cancel();
//                /// 主题切换动画200毫秒
//                _subscription = Stream.value(1).delay(Duration(milliseconds: 200)).listen((_) {
//                  if (!mounted) {
//                    return;
//                  }
//                  ThemeUtils.setSystemNavigationBarStyle(context, themeMode);
//                });
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_list[index]),
                    ),
                    Opacity(
                        opacity: themeMode == _list[index] ? 1 : 0,
                        child: Icon(Icons.done, color: Colors.blue)
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}