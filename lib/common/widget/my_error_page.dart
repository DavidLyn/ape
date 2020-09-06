import 'package:flutter/material.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';

/// 通用 出错 页面
class MyErrorPage extends StatelessWidget {

  final String errorMsg;

  MyErrorPage({this.errorMsg});

  @override
  Widget build(BuildContext context) {

    var showMsg = errorMsg.isEmpty ? '出错啦' : errorMsg;

    return Scaffold(
      appBar: AppBarWithOneIcon(
        backgroundColor: Colors.green,
        centerTitle: '出错了',
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
          showMsg,
          style: TextStyle(
            color: Colors.red,
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}
