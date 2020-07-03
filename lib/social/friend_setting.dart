import 'package:flutter/material.dart';

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
            appBar: AppBar(
              elevation: 0.5,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              textTheme: TextTheme(title: TextStyle(color: Colors.black,fontSize: 18)),
              leading: BackButton(),
              title: Text('资料设置'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(icon: Icon(Icons.add),onPressed: (){

                },),
              ],
            ),
            body: Text('资料设置'),
          ),
          onWillPop: () {
            return Future.value(true);
          },
        ),
    );
  }

}
