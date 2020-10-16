import 'package:flutter/material.dart';

/// 徽章 Provider
class BadgeProvider extends ChangeNotifier {

  // 徽章 map
  Map<String,int> _badgeMap = Map<String,int>();

  BadgeProvider() {
    _init();
  }

  // 初始化 _badgeMap
  void _init() async {

    notifyListeners();
  }

}
