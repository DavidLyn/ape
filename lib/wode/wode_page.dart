import 'package:flutter/material.dart';

import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/loaded_image_widgets.dart';
import 'package:ape/util/theme_utils.dart';

/// 我的 页面
///
class WodePage extends StatefulWidget {
  @override
  _WodePageState createState() => _WodePageState();
}

class _WodePageState extends State<WodePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color _iconColor = ThemeUtils.getIconColor(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            tooltip: '消息',
            onPressed: () {
              NavigatorUtils.push(context, GlobalRouter.message);
            },
            icon: LoadedAssetImageWidget(
              'wode/message',
              key: const Key('message'),
              width: 24.0,
              height: 24.0,
              color: _iconColor,
            ),
          ),
          IconButton(
            tooltip: '设置',
            onPressed: () {
              NavigatorUtils.push(context, GlobalRouter.setting);
            },
            icon: LoadedAssetImageWidget(
              'wode/setting',
              key: const Key('setting'),
              width: 24.0,
              height: 24.0,
              color: _iconColor,
            ),
          )
        ],

      ),
      body: Container(
        child: Text('hello wode'),
      ),
    );
  }

}