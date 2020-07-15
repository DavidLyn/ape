import 'dart:async';
import 'package:ape/common/sqlite_manager.dart';
import 'package:ape/common/constants.dart';

/// 好友 实体类
class FriendEntity {

  static String tableName = 'Friend';

  // int id;           // 自增序号
  int uid;          // 本 App 用户id
  int friendId;     // 好友 用户id
  String nickname;  // 昵称
  String avatar;    // 好友头像
  String profile;   // 好友简介
  int state;        // 0:好友  9:拉黑  2:发出加友请求等待对方确认  3:收到的加友请求尚未处理  4:拒绝收到的加友请求
  int isValid;      // 1:有效 0:删除
  DateTime friendTime;  // 确定好友关系时间
  DateTime deleteTime;  // 删除时间

  FriendEntity({
    //this.id,
    this.uid,
    this.friendId,
    this.nickname,
    this.avatar,
    this.profile,
    this.state,
    this.isValid,
    this.friendTime,
    this.deleteTime,
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    //map['id'] = id;
    map['uid'] = uid;
    map['friendId'] = friendId;
    map['nickname'] = nickname;
    map['avatar'] = avatar;
    map['profile'] = profile;
    map['state'] = state;
    map['friendTime'] = friendTime.millisecondsSinceEpoch;
    map['deleteTime'] = deleteTime.millisecondsSinceEpoch;
    return map;
  }

  static FriendEntity fromMap(Map<String, dynamic> map) {
    FriendEntity friend = new FriendEntity();
    //friend.id = map['id'];
    friend.uid = map['uid'];
    friend.friendId = map['friendId'];
    friend.nickname = map['nickname'];
    friend.avatar = map['avatar'];
    friend.profile = map['profile'];
    friend.state = map['state'];
    friend.friendTime = DateTime.fromMillisecondsSinceEpoch(map['friendTime']);
    friend.deleteTime = DateTime.fromMillisecondsSinceEpoch(map['deleteTime']);
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
    var result = await DbManager.db.rawQuery('select * from $tableName where uid=${UserInfo.user.uid} and state=0');
    return fromMapList(result.toList());
  }

  // 新增 Friend 记录
  static Future<int> insert(FriendEntity friend) async {
    int res = await DbManager.db.insert("$tableName", friend.toMap());
    return res;
  }

}