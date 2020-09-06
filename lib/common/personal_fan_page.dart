import 'package:flutter/material.dart';

import 'package:ape/common/widget/app_bar_with_one_icon.dart';

/// 粉丝 管理页面
class PersonalFanPage extends StatefulWidget {
  @override
  _PersonalFanPageState createState() => _PersonalFanPageState();

  final int uid;

  PersonalFanPage({this.uid});
}

class _PersonalFanPageState extends State<PersonalFanPage> {

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
    return Scaffold(
      appBar: AppBarWithOneIcon(
        backgroundColor: Colors.green,
        centerTitle: '粉丝',
      ),
      body: Container(
        child: Text(
            'fans',
          style: TextStyle(
            fontSize: 30,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

}
