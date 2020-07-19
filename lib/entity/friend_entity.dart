import 'dart:async';
import 'package:ape/common/sqlite_manager.dart';
import 'package:ape/common/constants.dart';

/// 好友 实体类
class FriendEntity {

  static String tableName = 'Friend';

  int uid;          // 本 App 用户id
  int friendId;     // 好友 用户id
  String nickname;  // 昵称
  String avatar;    // 好友头像
  String profile;   // 好友简介
  int state;        // 1:好友  0:拉黑
  int isValid;      // 1:有效 0:删除
  DateTime friendTime;  // 成为好友时间
  DateTime rejectTime;  // 拉黑时间
  DateTime deleteTime;  // 删除时间

  FriendEntity({
    this.uid,
    this.friendId,
    this.nickname,
    this.avatar,
    this.profile,
    this.state,
    this.isValid,
    this.rejectTime,
    this.friendTime,
    this.deleteTime,
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['uid'] = uid;
    map['friendId'] = friendId;
    map['nickname'] = nickname;
    map['avatar'] = avatar;
    map['profile'] = profile;
    map['state'] = state;
    map['isValid'] = isValid;
    map['friendTime'] = friendTime?.millisecondsSinceEpoch;
    map['rejectTime'] = rejectTime?.millisecondsSinceEpoch;
    map['deleteTime'] = deleteTime?.millisecondsSinceEpoch;
    return map;
  }

  static FriendEntity fromMap(Map<String, dynamic> map) {
    FriendEntity friend = new FriendEntity();
    friend.uid = map['uid'];
    friend.friendId = map['friendId'];
    friend.nickname = map['nickname'];
    friend.avatar = map['avatar'];
    friend.profile = map['profile'];
    friend.state = map['state'];
    friend.isValid = map['isValid'];
    friend.friendTime = map['friendTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['friendTime']) : null;
    friend.rejectTime = map['rejectTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['rejectTime']) : null;
    friend.deleteTime = map['deleteTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['deleteTime']) : null;
    return friend;
  }

  static List<FriendEntity> fromMapList(dynamic mapList) {
    List<FriendEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  // 获取当前用户的好友列表
  static Future<List> getFriendList() async {
    var result = await DbManager.db.rawQuery('select * from $tableName where uid=${UserInfo.user.uid} and state=1');
    return fromMapList(result.toList());
  }

  // 新增 Friend 记录
  static Future<int> insert(FriendEntity friend) async {
    int res = await DbManager.db.insert("$tableName", friend.toMap());
    return res;
  }

}