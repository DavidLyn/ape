import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ape/entity/friend_entity.dart';
import 'package:ape/entity/friend_askfor_entity.dart';
import 'package:ape/entity/friend_inviting_entity.dart';
import 'package:ape/mqtt/mqtt_provider.dart';
import 'package:ape/mqtt/mqtt_message.dart';
import 'package:ape/common/constants.dart';

/// 保存 好友 信息的 provider
class FriendProvider extends ChangeNotifier {

  // 注意下述方法创建无固定长度 list
  // 朋友列表
  List<FriendEntity> _friends = List<FriendEntity>();
  List<FriendEntity> get friends => _friends;

  // 朋友请求 列表
  List<FriendAskforEntity> _friendsAskfor = List<FriendAskforEntity>();
  List<FriendAskforEntity> get friendsAskfor => _friendsAskfor;

  // 朋友邀约 列表
  List<FriendInvitingEntity> _friendsInviting = List<FriendInvitingEntity>();
  List<FriendInvitingEntity> get friendsInviting => _friendsInviting;

  FriendProvider() {
    _getFriendsFromDB();
  }

  // 从本地 DB 中读取 friend 信息
  _getFriendsFromDB() async {
    var dbList = await FriendEntity.getFriendList();

    for (var obj in dbList) {
      _friends.add(obj);
    }

    var askforList = await FriendAskforEntity.getFriendAskforList();
    for (var obj in askforList) {
      _friendsAskfor.add(obj);
      //print('FriendAskfor from db = ${_friendsAskfor[_friendsAskfor.length-1].toMap()}');
    }

    var invitingList = await FriendInvitingEntity.getFriendInvitingList();
    for (var obj in invitingList) {
      _friendsInviting.add(obj);
      //print('FriendInviting from db = ${_friendsInviting[_friendsInviting.length-1].toMap()}');
    }

  }

  // ---------------------------------------------------------------------------
  // 接受邀约 增加新朋友
  void acceptInviting(int index) async {

    // 发送 邀请 响应
    var message = MQTTMessage();
    message.type = 1;    // 响应报文
    message.command = MQTTProvider.commandMakeFriendResponse;
    message.senderId = UserInfo.user.uid;
    message.receiverId = 0;     // 0 代表 后台
    message.sendTime = DateTime.now();
    message.msgId = _friendsInviting[index].msgId;

    Map<String,String> map = {'result':'yes','friendId':_friendsInviting[index].friendId.toString()};
    message.payload = jsonEncode(map);

    if (!MQTTProvider.publish(message: jsonEncode(message))) {
      print('Make friend response sended error!');
      return;
    }

    // 在数据库中添加好友记录
    FriendEntity friend = FriendEntity();
    friend.uid = _friendsInviting[index].uid;
    friend.friendId = _friendsInviting[index].friendId;
    friend.nickname = _friendsInviting[index].nickname;
    friend.avatar = _friendsInviting[index].avatar;
    friend.profile = _friendsInviting[index].profile;
    friend.gender = _friendsInviting[index].gender;
    friend.state = 1;
    friend.isValid = 1;
    friend.friendTime = DateTime.now();

    await FriendEntity.insert(friend);
    _friends.add(friend);

    // 修改邀请记录状态
    var dealTime = DateTime.now();

    FriendInvitingEntity.updateState(_friendsInviting[index].id, 1, dealTime);
    _friendsInviting[index].state = 1;
    _friendsInviting[index].dealTime = dealTime;

    notifyListeners();
  }

  // 拒绝 邀约
  void rejectInviting(int index) async {

    // 发送 邀请 响应
    var message = MQTTMessage();
    message.type = 1;    // 响应报文
    message.command = MQTTProvider.commandMakeFriendResponse;
    message.senderId = UserInfo.user.uid;
    message.receiverId = 0;     // 0 代表 后台
    message.sendTime = DateTime.now();
    message.msgId = _friendsInviting[index].msgId;

    Map<String,String> map = {'result':'no','friendId':_friendsInviting[index].friendId.toString()};
    message.payload = jsonEncode(map);

    if (!MQTTProvider.publish(message: jsonEncode(message))) {
      print('Make friend response sended error!');
      return;
    }

    // 修改邀请记录状态
    var dealTime = DateTime.now();

    FriendInvitingEntity.updateState(_friendsInviting[index].id, 2, dealTime);
    _friendsInviting[index].state = 2;
    _friendsInviting[index].dealTime = dealTime;

    notifyListeners();
  }

  // 删除 邀约
  void deleteInviting(FriendInvitingEntity obj) {

    _friendsInviting.remove(obj);
    FriendInvitingEntity.delete(obj.id);

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 增加 加友申请
  void addFriendAskfor(FriendAskforEntity friendAskfor) async {
    await FriendAskforEntity.insert(friendAskfor);

    _friendsAskfor.insert(0, friendAskfor);

    notifyListeners();
  }

  // 删除 申请
  void deleteAskfor(FriendAskforEntity obj) {

    _friendsAskfor.remove(obj);
    FriendAskforEntity.delete(obj.id);

    notifyListeners();
  }


  // 增加 加友邀约
  void addFriendInviting(FriendInvitingEntity friendInviting) async {

    await FriendInvitingEntity.insert(friendInviting);

    _friendsInviting.insert(0, friendInviting);

    notifyListeners();
  }

  // 加友邀约响应
  void invitingResponse(String msgId, String result) async {

    int index = -1;

    for (int i = 0; i < _friendsAskfor.length; i++) {
      if (_friendsAskfor[i].msgId == msgId) {
        index = i;
        break;
      }
    }

    if (index == -1) {
      print('!!!!!!!!!!!error : no equal msgId = $msgId');
      return;
    }

    var state = 2;   // 缺省 拒绝
    if (result == 'yes') {
      state = 1;     // 接受
    }

    // 修改 加友请求记录 状态
    FriendAskforEntity.updateState(_friendsAskfor[index].id, state);
    _friendsAskfor[index].state = state;

    // 接受时在数据库中添加好友记录
    if (state == 1) {
      FriendEntity friend = FriendEntity();
      friend.uid = _friendsAskfor[index].uid;
      friend.friendId = _friendsAskfor[index].friendId;
      friend.nickname = _friendsAskfor[index].nickname;
      friend.avatar = _friendsAskfor[index].avatar;
      friend.profile = _friendsAskfor[index].profile;
      friend.gender = _friendsAskfor[index].gender;
      friend.state = 1;
      friend.isValid = 1;
      friend.friendTime = DateTime.now();

      await FriendEntity.insert(friend);
      _friends.add(friend);

    }

    notifyListeners();
  }

  // ---------------------------------------------------
  // 删除 好友
  void deleteFriend(FriendEntity obj) {

    _friends.remove(obj);
    FriendEntity.delete(obj.id);

    notifyListeners();
  }

  // 拉黑 好友
  void blacklistFriend(FriendEntity obj) {

    obj.state = 0;
    obj.rejectTime = DateTime.now();

    FriendEntity.blacklist(obj.id);

    // Todo
    // 向后台发送拉黑消息

    notifyListeners();

  }

}