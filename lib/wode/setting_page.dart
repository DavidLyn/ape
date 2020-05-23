import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart' as flutter_stars;

import 'package:ape/global/global_router.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/common/widget/loaded_image_widgets.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/base_dialog.dart';

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
            _ClickItem(
                title: '账号管理',
                onTap: () => NavigatorUtils.push(context, '')
            ),
            _ClickItem(
                title: '清除缓存',
                content: '23.5MB',
                onTap: () {}
            ),
            _ClickItem(
                title: '夜间模式',
                content: themeMode,
                onTap: () => NavigatorUtils.push(context, GlobalRouter.changeBrightness)
            ),
            _ClickItem(
                title: '关于我们',
                onTap: () => NavigatorUtils.push(context, GlobalRouter.aboutUs)
            ),
            _ClickItem(
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

/// setting 页面中使用 功能项 widget
///
class _ClickItem extends StatelessWidget {

  static const Widget _arrowRight = const LoadedAssetImageWidget('common/arrow_right', height: 16.0, width: 16.0);

  const _ClickItem({
    Key key,
    this.onTap,
    @required this.title,
    this.content: '',
    this.textAlign: TextAlign.start,
    this.maxLines: 1
  }): super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15.0),
        padding: const EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
        constraints: BoxConstraints(
            maxHeight: double.infinity,
            minHeight: 50.0
        ),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
              bottom: Divider.createBorderSide(context, width: 0.6),
            )
        ),
        child: Row(
          //为了数字类文字居中
          crossAxisAlignment: maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            Text(title),
            const Spacer(),
            SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: Text(
                  content,
                  maxLines: maxLines,
                  textAlign: maxLines == 1 ? TextAlign.right : textAlign,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14)
              ),
            ),
            SizedBox(width: 8),
            Opacity(
              // 无点击事件时，隐藏箭头图标
              opacity: onTap == null ? 0 : 1,
              child: Padding(
                padding: EdgeInsets.only(top: maxLines == 1 ? 0.0 : 2.0),
                child: _arrowRight,
              ),
            )
          ],
        ),
      ),
    );
  }
}
