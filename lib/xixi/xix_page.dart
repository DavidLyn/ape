import 'package:flutter/material.dart';
import 'package:ape/common/widget/my_app_bar.dart';

/// 习习 页面
///
class XixiPage extends StatefulWidget {
  @override
  _XixiPageState createState() => _XixiPageState();
}

class _XixiPageState extends State<XixiPage> {

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
        centerTitle: '习习',
        isBack: false,
      ),
      body: Text('xixi'),
    );
  }

}
