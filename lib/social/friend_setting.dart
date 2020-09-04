import 'package:flutter/material.dart';
import 'package:common_utils/common_utils.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';
import 'package:ape/util/timeline_utils.dart';

/// 设置好友信息
class FriendSetting extends StatefulWidget {

  int uid;

  FriendSetting({this.uid});

  @override
  _FriendSettingState createState() => _FriendSettingState();
}

class _FriendSettingState extends State<FriendSetting> {

  @override
  void initState() {
    super.initState();
    setLocaleInfo('aaa',ZhInfo());
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var timeLine = TimelineUtils.format(DateTime.now().millisecondsSinceEpoch - 1000000,
        DateTime.now().millisecondsSinceEpoch);

    return Scaffold(
      appBar: AppBarWithOneIcon(
        backgroundColor: Colors.green,
        centerTitle: '资料设置',
        actionIcon: Icon(Icons.add),
        actionName: '添加',
        onPressed: () {

        },
      ),
      body: Column(
        children: <Widget>[
          Text('Hello world:$timeLine'),
        ],
      ),
    );
  }

}
