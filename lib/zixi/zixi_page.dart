import 'package:flutter/material.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/global/global_router.dart';

/// 自习 页面
///
class ZixiPage extends StatefulWidget {
  @override
  _ZixiPageState createState() => _ZixiPageState();
}

class _ZixiPageState extends State<ZixiPage> {

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
      appBar: MyAppBar(
        centerTitle: '自习',
        actionName: '记录',
        isBack: false,
        onPressed: () {
          NavigatorUtils.push(context, GlobalRouter.writing);
        },
      ),
      body: Text('zixi'),
    );
  }

}
