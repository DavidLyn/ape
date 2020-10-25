import 'dart:async';
import 'package:ape/common/sqlite_manager.dart';
import 'package:ape/common/constants.dart';

class GrouperEntity {
  static String tableName = 'Grouper';

  int id;                         // 自增序号,主键
  int uid;                        // 所属 uid
  int groupId;                    // 群组 ID
  int groupUid;                   // 群成员 uid
  String avatar;                  // 群成员 头像
  int role;                       // 角色 0-群主 1-管理员 9-普通组员
  DateTime joinTime;              // 入群时间
  DateTime updateTime;            // 修改时间
  DateTime quitTime;              // 退群时间
  int state;                      // 状态 1-正常 0-已退群

  GrouperEntity({
   this.id,
   this.uid,
   this.groupId,
   this.groupUid,
   this.avatar,
   this.role,
   this.joinTime,
   this.updateTime,
   this.quitTime,
   this.state : 1,
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id'] = id;
    map['uid'] = uid;
    map['groupId'] = groupId;
    map['groupUid'] = groupUid;
    map['avatar'] = avatar;
    map['role'] = role;
    map['joinTime'] = joinTime?.millisecondsSinceEpoch;
    map['updateTime'] = updateTime?.millisecondsSinceEpoch;
    map['quitTime'] = quitTime?.millisecondsSinceEpoch;
    map['state'] = state;

    return map;
  }

  static GrouperEntity fromMap(Map<String, dynamic> map) {
    GrouperEntity grouper = new GrouperEntity();

    grouper.id = map['id'];
    grouper.uid = map['uid'];
    grouper.groupId = map['groupId'];
    grouper.groupUid = map['groupUid'];
    grouper.avatar = map['avatar'];
    grouper.role = map['role'];
    grouper.joinTime = map['joinTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['joinTime']) : null;
    grouper.updateTime = map['updateTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateTime']) : null;
    grouper.quitTime = map['quitTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['quitTime']) : null;
    grouper.state = map['state'];

    return grouper;
  }

  static List<GrouperEntity> fromMapList(dynamic mapList) {
    List<GrouperEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  // 新增 群组成员 记录
  static Future<int> insert(GrouperEntity grouper) async {
    int id = await DbManager.db.insert("$tableName", grouper.toMap());

    grouper.id = id;

    return id;
  }

}
