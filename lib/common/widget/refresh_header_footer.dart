import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 定制水滴下拉头
class MyWaterDropHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaterDropHeader(
      refresh: Text('正在刷新',style: TextStyle(color: Colors.black12,fontSize: 12)),
      complete: Text('刷新完成',style: TextStyle(color: Colors.black12,fontSize: 12)),
      failed:  Text('刷新失败',style: TextStyle(color: Colors.black12,fontSize: 12)),
      waterDropColor: Colors.yellow,
    );
  }
}

/// 定制经典 footer
class MyClassicFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      failedText: '加载失败',
      idleText: '空闲',
      loadingText: '正在加载',
      noDataText: '没有数据',
    );
  }
}
