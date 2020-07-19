import 'dart:async';
import 'package:ape/common/sqlite_manager.dart';
import 'package:ape/common/constants.dart';

/// 好友邀约 实体类
class FriendInvitingEntity {

  static String tableName = 'FriendInviting';

  int uid;                // 本 App 用户id
  int friendId;           // 好友 用户id
  String nickname;        // 昵称
  String avatar;          // 好友头像
  String profile;         // 好友简介
  String leavingWords;    // 留言
  DateTime recieveTime;   // 收到时间
  int state;              // 当前状态  0 - 收到未处理 1 - 接受成为好友 2 - 拒绝成为好友
  DateTime dealTime;      // 处理时间
  int isValid;            // 1:有效 0:删除
  DateTime deleteTime;    // 删除时间

  FriendInvitingEntity({
    this.uid,
    this.friendId,
    this.nickname,
    this.avatar,
    this.profile,
    this.leavingWords,
    this.recieveTime,
    this.state,
    this.dealTime,
    this.isValid,
    this.deleteTime,
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['uid'] = uid;
    map['friendId'] = friendId;
    map['nickname'] = nickname;
    map['avatar'] = avatar;
    map['profile'] = profile;
    map['leavingWords'] = leavingWords;
    map['recieveTime'] = recieveTime?.millisecondsSinceEpoch;
    map['state'] = state;
    map['dealTime'] = dealTime?.millisecondsSinceEpoch;
    map['isValid'] = isValid;
    map['deleteTime'] = deleteTime?.millisecondsSinceEpoch;
    return map;
  }

  static FriendInvitingEntity fromMap(Map<String, dynamic> map) {
    FriendInvitingEntity friendInviting = new FriendInvitingEntity();
    friendInviting.uid = map['uid'];
    friendInviting.friendId = map['friendId'];
    friendInviting.nickname = map['nickname'];
    friendInviting.avatar = map['avatar'];
    friendInviting.profile = map['profile'];
    friendInviting.leavingWords = map['leavingWords'];
    friendInviting.recieveTime = map['recieveTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['recieveTime']) : null;
    friendInviting.state = map['state'];
    friendInviting.dealTime = map['dealTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dealTime']) : null;
    friendInviting.isValid = map['isValid'];
    friendInviting.deleteTime = map['deleteTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['deleteTime']) : null;
    return friendInviting;
  }

  static List<FriendInvitingEntity> fromMapList(dynamic mapList) {
    List<FriendInvitingEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  // 获取当前用户的好友邀约列表
  static Future<List> getFriendInvitingList() async {
    var result = await DbManager.db.rawQuery('select * from $tableName where uid=${UserInfo.user.uid} and state=1 order by recieveTime desc');
    return fromMapList(result.toList());
  }

  // 新增 FriendInvitingEntity 记录
  static Future<int> insert(FriendInvitingEntity friend) async {
    int res = await DbManager.db.insert("$tableName", friend.toMap());
    return res;
  }

}
