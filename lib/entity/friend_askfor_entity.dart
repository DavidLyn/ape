import 'dart:async';
import 'package:ape/common/sqlite_manager.dart';
import 'package:ape/common/constants.dart';

/// 好友申请 实体类
class FriendAskforEntity {

  static String tableName = 'FriendAskfor';

  int id;                 // 主键
  String msgId;           // 消息ID,用于关联 请求 和 响应
  int uid;                // 本 App 用户id
  int friendId;           // 好友 用户id
  String nickname;        // 昵称
  String avatar;          // 好友头像
  String profile;         // 好友简介
  int gender;             // 性别 1-男 2-女 0-保密
  String leavingWords;    // 留言
  DateTime askforTime;    // 请求时间
  int state;              // 当前状态  0 - 发出请求尚未收到响应  1 - 对方已响应且已接受成为好友 2 - 对方已响应且已拒绝成为好友
  DateTime responseTime;  // 收到响应时间
  int isValid;            // 1:有效 0:删除
  DateTime deleteTime;    // 删除时间

  FriendAskforEntity({
    this.id,
    this.msgId,
    this.uid,
    this.friendId,
    this.nickname,
    this.avatar,
    this.profile,
    this.gender,
    this.leavingWords,
    this.askforTime,
    this.state : 0,
    this.responseTime,
    this.isValid : 1,
    this.deleteTime,
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['msgId'] = msgId;
    map['uid'] = uid;
    map['friendId'] = friendId;
    map['nickname'] = nickname;
    map['avatar'] = avatar;
    map['profile'] = profile;
    map['gender'] = gender;
    map['leavingWords'] = leavingWords;
    map['askforTime'] = askforTime?.millisecondsSinceEpoch;
    map['state'] = state;
    map['responseTime'] = responseTime?.millisecondsSinceEpoch;
    map['isValid'] = isValid;
    map['deleteTime'] = deleteTime?.millisecondsSinceEpoch;
    return map;
  }

  static FriendAskforEntity fromMap(Map<String, dynamic> map) {
    FriendAskforEntity friendAskfor = new FriendAskforEntity();
    friendAskfor.id = map['id'];
    friendAskfor.msgId = map['msgId'];
    friendAskfor.uid = map['uid'];
    friendAskfor.friendId = map['friendId'];
    friendAskfor.nickname = map['nickname'];
    friendAskfor.avatar = map['avatar'];
    friendAskfor.profile = map['profile'];
    friendAskfor.gender = map['gender'];
    friendAskfor.leavingWords = map['leavingWords'];
    friendAskfor.askforTime = map['askforTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['askforTime']) : null;
    friendAskfor.state = map['state'];
    friendAskfor.responseTime = map['responseTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['responseTime']) : null;
    friendAskfor.isValid = map['isValid'];
    friendAskfor.deleteTime = map['deleteTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['deleteTime']) : null;
    return friendAskfor;
  }

  static List<FriendAskforEntity> fromMapList(dynamic mapList) {
    List<FriendAskforEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  // 获取当前用户的好友请求列表
  static Future<List> getFriendAskforList() async {
    var result = await DbManager.db.rawQuery('select * from $tableName where uid=${UserInfo.user.uid} and isValid=1 order by askforTime desc');
    return fromMapList(result.toList());
  }

  // 新增 FriendAskfor 记录
  static Future<int> insert(FriendAskforEntity friend) async {
    int id = await DbManager.db.insert("$tableName", friend.toMap());

    friend.id = id;

    return id;
  }

  // 修改记录状态
  static Future<int> updateState(int id,int state) async {
    var responseTime = DateTime.now().millisecondsSinceEpoch;

    var count = await DbManager.db.rawUpdate('update $tableName set state = ?, responseTime = ? where id = ?',[state, responseTime, id]);

    return count;
  }

  // 删除记录
  static Future<int> delete(int id) async {
    var count = await DbManager.db.rawUpdate('update $tableName set isValid = 0, deleteTime = ? where id = ?',[DateTime.now().millisecondsSinceEpoch, id]);
    return count;
  }

}

