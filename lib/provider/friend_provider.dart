import 'package:flutter/material.dart';
import 'package:ape/entity/friend_entity.dart';

/// 保存 好友 信息的 provider
class FriendProvider extends ChangeNotifier {

  List<FriendEntity> _friends;

  List<FriendEntity> get friends => _friends;

  FriendProvider() {
    _getFriendsFromDB();
  }

  // 从本地 DB 中读取 friend 信息
  _getFriendsFromDB() async {
    _friends = await FriendEntity.getFriendList();

    if (_friends == null) {
      _friends = List<FriendEntity>();
    }
  }

}