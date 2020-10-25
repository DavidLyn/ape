import 'dart:async';
import 'package:ape/common/sqlite_manager.dart';
import 'package:ape/common/constants.dart';

class GroupMainEntity {

  static String tableName = 'GroupMain';

  int id; // 自增序号,主键
  int uid; // 所属 uid
  int groupId; // 群组 ID
  String tag; // 标签
  String name; // 群组名
  String avatar; // 头像
  String profile; // 群组简介
  DateTime createTime; // 创建时间
  DateTime updateTime; // 修改时间
  DateTime dismissTime; // 解散时间
  int state; // 状态 1-正常 0-解散

  GroupMainEntity({
    this.id,
    this.uid,
    this.groupId,
    this.tag,
    this.name,
    this.avatar,
    this.profile,
    this.createTime,
    this.updateTime,
    this.dismissTime,
    this.state,
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id'] = id;
    map['uid'] = uid;
    map['groupId'] = groupId;
    map['tag'] = tag;
    map['name'] = name;
    map['avatar'] = avatar;
    map['profile'] = profile;
    map['createTime'] = createTime?.millisecondsSinceEpoch;
    map['updateTime'] = updateTime?.millisecondsSinceEpoch;
    map['dismissTime'] = dismissTime?.millisecondsSinceEpoch;
    map['state'] = state;

    return map;
  }

  static GroupMainEntity fromMap(Map<String, dynamic> map) {
    GroupMainEntity group = new GroupMainEntity();

    group.id = map['id'];
    group.uid = map['uid'];
    group.groupId = map['groupId'];
    group.tag = map['tag'];
    group.name = map['name'];
    group.avatar = map['avatar'];
    group.profile = map['profile'];
    group.createTime = map['createTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createTime']) : null;
    group.updateTime = map['updateTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateTime']) : null;
    group.dismissTime = map['dismissTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dismissTime']) : null;
    group.state = map['state'];

    return group;
  }

  static List<GroupMainEntity> fromMapList(dynamic mapList) {
    List<GroupMainEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  // 获取当前用户的群组列表
  static Future<List> getGroupList() async {
    var result = await DbManager.db.rawQuery('select * from $tableName where uid=${UserInfo.user.uid} and state=1');
    return fromMapList(result.toList());
  }

  // 新增 群组 记录
  static Future<int> insert(GroupMainEntity group) async {
    int id = await DbManager.db.insert("$tableName", group.toMap());

    group.id = id;

    return id;
  }

}