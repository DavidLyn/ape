import 'package:flutter/material.dart';

import 'package:badges/badges.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/loaded_image_widgets.dart';
import 'package:ape/wode/message_page.dart';

/// 我的 页面
///
class WodePage extends StatefulWidget {
  @override
  _WodePageState createState() => _WodePageState();
}

class _WodePageState extends State<WodePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 为实现 AutomaticKeepAliveClientMixin 的功能所必须

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Badge(
//          badgeContent: Text('1',style: TextStyle(fontSize: 6),),
          badgeContent: null,
          //badgeColor: Colors.yellow,
//          position: BadgePosition.topRight(top:-8,right: -8),
          position: BadgePosition.topRight(top:-4,right: -4),
          shape: BadgeShape.circle,
          showBadge : true,
          child: Text(
            '我的',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: '消息',
            onPressed: () {
              //NavigatorUtils.push(context, GlobalRouter.message);
              showSearch(context: context, delegate: SearchBarDelegate());
            },
            icon: LoadedAssetImageWidget(
              'wode/message',
              key: const Key('message'),
              width: 24.0,
              height: 24.0,
              color: Colors.black,
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
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text('Hello Wode',style: TextStyle(color: Colors.black,fontSize: 30),),
        ),
      ),
    );
  }
}
