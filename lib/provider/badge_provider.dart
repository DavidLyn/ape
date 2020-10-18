import 'package:flutter/material.dart';

import 'package:badges/badges.dart';
import 'package:ape/entity/badge_entity.dart';

// 描述关联关系
Map<String, List<String>> _badgeRelations = {
  'example1': ['1', '2'],
  'example2': ['1', '2'],
};

/// 徽章 Provider
class BadgeProvider extends ChangeNotifier {

  static String pageHomeWode = 'pageHomeWode';
  static String addFriendInviting = 'addFriendInviting';
  static String addNewFriend = 'addNewFriend';

  // 徽章 map
  Map<String, int> _badgeMap = Map<String, int>();

  BadgeProvider() {
    _init();
  }

  // 初始化 _badgeMap
  void _init() async {
    var list = await BadgeEntity.getBadgeList();

    for (BadgeEntity obj in list) {
      _badgeMap[obj.keyName] = obj.value;
    }

    notifyListeners();
  }

  // 递增
  void increment(String keyName, {int step: 1}) {
    if (_badgeMap.containsKey(keyName)) {
      _badgeMap[keyName] = _badgeMap[keyName] + step;
    } else {
      _badgeMap[keyName] = step;
    }

    BadgeEntity.increment(keyName, step: step);

    if (_badgeRelations.containsKey(keyName)) {
      var list = _badgeRelations[keyName];
      for (var key in list) {
        increment(key);
      }
    }

    notifyListeners();
  }

  // 重置
  void reset(String keyName) {
    _badgeMap[keyName] = 0;

    BadgeEntity.reset(keyName);

    notifyListeners();
  }

  // 获取 badge
  Widget getBadge({@required String key, @required Widget child, bool withContent: true}) {
    if (!_badgeMap.containsKey(key)) {
      return child;
    }

    var count = _badgeMap[key];
    var content;
    if (count == 0) {
      return child;
    } else {
      if (count < 10) {
        content = count.toString();
      } else {
        content = 'N';
      }
    }

    var item;
    if (withContent) {
      item = Text(
        content,
        style: TextStyle(fontSize: 6),
      );
    }

    return Badge(
      badgeContent: item,
//    position: BadgePosition.topRight(top:-8,right: -8),
      position: BadgePosition.topRight(top: -4, right: -4),
      shape: BadgeShape.circle,
      child: child,
      showBadge: true,
    );
  }
}
