import 'package:flutter/material.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';

/// 关注 管理页面
class PersonalFollowPage extends StatefulWidget {
  @override
  _PersonalFollowPageState createState() => _PersonalFollowPageState();

  final int uid;

  PersonalFollowPage({this.uid});
}

class _PersonalFollowPageState extends State<PersonalFollowPage> {

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
        centerTitle: '关注',
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

