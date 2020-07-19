import 'package:flutter/material.dart';
import 'package:ape/entity/friend_entity.dart';
import 'package:ape/entity/friend_askfor_entity.dart';
import 'package:ape/entity/friend_inviting_entity.dart';

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
    }

    var invitingList = await FriendInvitingEntity.getFriendInvitingList();
    for (var obj in invitingList) {
      _friendsInviting.add(obj);
    }

  }

  // 增加新朋友
  void addFriend(FriendEntity friend) {
    _friends.add(friend);

    FriendEntity.insert(friend);

    notifyListeners();
  }

  // 增加 加友申请
  void addFriendAskfor(FriendAskforEntity friendAskfor) {
    _friendsAskfor.insert(0, friendAskfor);

    FriendAskforEntity.insert(friendAskfor);

    notifyListeners();
  }

  // 增加 加友邀约
  void addFriendInviting(FriendInvitingEntity friendInviting) {
    _friendsInviting.insert(0, friendInviting);

    FriendInvitingEntity.insert(friendInviting);

    notifyListeners();
  }

}