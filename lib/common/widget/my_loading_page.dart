import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';

/// 通用 载入提示 页面
class MyLoadingPage extends StatelessWidget {

  final String title;
  final String showMsg;

  MyLoadingPage({this.title,this.showMsg});

  @override
  Widget build(BuildContext context) {
    var tt = title==null ? '' : title;
    var mm = showMsg==null? '正在载入...' : showMsg;

    return Scaffold(
      appBar: AppBarWithOneIcon(
        centerTitle: tt,
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
            child: Shimmer.fromColors(
              baseColor: Colors.yellow,
              highlightColor: Colors.red,
              child: Text(
                mm,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      ),
    );

  }
}
