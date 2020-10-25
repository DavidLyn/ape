import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ape/entity/group_main_entity.dart';
import 'package:ape/entity/grouper_entity.dart';

/// 群组 provider
class GroupProvider extends ChangeNotifier {

  // group 列表
  List<GroupMainEntity> _groups = List<GroupMainEntity>();
  List<GroupMainEntity> get groups => _groups;

  GroupProvider() {
    _getGroupsFromDB();
  }

  // 从本地 DB 中读取 group 信息
  _getGroupsFromDB() async {
    var dbList = await GroupMainEntity.getGroupList();

    for (var obj in dbList) {
      _groups.add(obj);
    }
  }


  // 重载群组等信息
  void reloadGroups() async {
    _groups.clear();

    await _getGroupsFromDB();

    notifyListeners();
  }

  // 增加新群组
  void addGroup(GroupMainEntity group) async {

    await GroupMainEntity.insert(group);
    _groups.add(group);

    notifyListeners();

  }

}
