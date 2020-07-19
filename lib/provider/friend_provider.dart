import 'package:flutter/material.dart';
import 'package:ape/entity/friend_entity.dart';

/// 保存 好友 信息的 provider
class FriendProvider extends ChangeNotifier {

  // 注意下述方法创建无固定长度 list
  List<FriendEntity> _friends = List<FriendEntity>();

  List<FriendEntity> get friends => _friends;

  FriendProvider() {
    _getFriendsFromDB();
  }

  // 从本地 DB 中读取 friend 信息
  _getFriendsFromDB() async {
    var dbList = await FriendEntity.getFriendList();

    for (var obj in dbList) {
      _friends.add(obj);
    }
  }

  // 增加新朋友
  void addFriend(FriendEntity friend) {
    _friends.add(friend);

    FriendEntity.insert(friend);

    notifyListeners();
  }

}