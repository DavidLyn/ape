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

    print('_friends length = ${_friends.length}');

    var askforList = await FriendAskforEntity.getFriendAskforList();
    for (var obj in askforList) {
      _friendsAskfor.add(obj);
    }

    print('_friendsAskfor length = ${_friendsAskfor.length}');

    var invitingList = await FriendInvitingEntity.getFriendInvitingList();
    for (var obj in invitingList) {
      _friendsInviting.add(obj);
    }

    print('_friendsInviting length = ${_friendsInviting.length}');

  }

  // 增加新朋友
  void addFriend(int index) async {
    FriendInvitingEntity invitingEntity = _friendsInviting[index];

    FriendEntity friend = FriendEntity();

    friend.uid = invitingEntity.uid;
    friend.friendId = invitingEntity.friendId;
    friend.nickname = invitingEntity.nickname;
    friend.avatar = invitingEntity.avatar;
    friend.profile = invitingEntity.profile;
    friend.state = 1;
    friend.isValid = 1;
    friend.friendTime = DateTime.now();

    // 添加好友记录
    await FriendEntity.insert(friend);
    _friends.add(friend);

    // 修改邀请记录状态
    FriendInvitingEntity.updateState(invitingEntity.id, 1);

    notifyListeners();
  }

  // 增加 加友申请
  void addFriendAskfor(FriendAskforEntity friendAskfor) async {
    await FriendAskforEntity.insert(friendAskfor);

    _friendsAskfor.insert(0, friendAskfor);

    notifyListeners();
  }

  // 增加 加友邀约
  void addFriendInviting(FriendInvitingEntity friendInviting) async {

    await FriendInvitingEntity.insert(friendInviting);

    _friendsInviting.insert(0, friendInviting);

    notifyListeners();
  }

  // 拒绝 邀约
  void rejectInviting(int index) async {
    var id = _friendsInviting[index].id;

    FriendInvitingEntity.updateState(id, 2);
    _friendsInviting[index].state = 2;

    notifyListeners();
  }

}