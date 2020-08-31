import 'package:flutter/material.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';

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
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          child: Scaffold(
              appBar: AppBarWithOneIcon(
                backgroundColor: Colors.green,
                centerTitle: '资料设置',
                actionIcon: Icon(Icons.add),
                actionName: '添加',
                onPressed: (){

                },
              ),
            body: Column(
              children: <Widget>[
                Text('Hello world!'),
              ],
            ),
          ),
          onWillPop: () {
            return Future.value(true);
          },
        ),
    );
  }

}
