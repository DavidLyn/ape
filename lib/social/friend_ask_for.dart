import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:ape/mqtt/mqtt_message.dart';
import 'package:ape/mqtt/mqtt_provider.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/entity/friend_askfor_entity.dart';
import 'package:ape/provider/friend_provider.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';

/// 发出加好友请求
class FriendAskFor extends StatefulWidget {

  final int friendId;
  final String nickname;
  final String avatar;
  final String profile;
  final int gender;

  FriendAskFor({this.friendId,this.nickname,this.avatar,this.profile,this.gender});

  @override
  _FriendAskForState createState() => _FriendAskForState();
}

class _FriendAskForState extends State<FriendAskFor> {

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.text = '我是${UserInfo.user.nickname}';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithOneIcon(
        backgroundColor: Colors.green,
        centerTitle: '加友请求',
        actionIcon: Icon(Icons.playlist_add_check),
        actionName: '请求',
        onPressed: () {
          _sendAskFor(context);
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: TextField(
            maxLength: 200,
            maxLines: 6,
            autofocus: true,
            controller: _controller,
            keyboardType: TextInputType.text,
            //style: TextStyles.textDark14,
            decoration: InputDecoration(
              hintText: '输入加好友请求',
              border: InputBorder.none,
              //hintStyle: TextStyles.textGrayC14
            )
        ),
      ),
    );
  }

  // 发送加友申请
  _sendAskFor(BuildContext context) {

    var message = MQTTMessage();
    message.type = 0;
    message.command = MQTTProvider.commandMakeFriend;
    message.senderId = UserInfo.user.uid;
    message.receiverId = 0;     // 0 代表 后台
    message.sendTime = DateTime.now();

    // 设置 消息ID
    message.msgId = Uuid().v1();

    Map<String,String> map = {'friendId':widget.friendId.toString(),
      'leavingWords':_controller.text};

    message.payload = jsonEncode(map);

    if (MQTTProvider.publish(message: jsonEncode(message))) {
      // 向 FriendAskfor 表写入记录
      var friendAskfor = FriendAskforEntity();
      friendAskfor.uid = UserInfo.user.uid;
      friendAskfor.msgId = message.msgId;
      friendAskfor.friendId = widget.friendId;
      friendAskfor.nickname = widget.nickname;
      friendAskfor.avatar = widget.avatar;
      friendAskfor.profile = widget.profile;
      friendAskfor.gender = widget.gender;
      friendAskfor.askforTime = DateTime.now();
      friendAskfor.leavingWords = _controller.text;
      friendAskfor.isValid = 1;   // 未删除
      friendAskfor.state = 0;     // 发出请求尚未收到响应

      // 注意:修改 Provider 数据 listen 为 false
      Provider.of<FriendProvider>(context,listen: false).addFriendAskfor(friendAskfor);

      Navigator.pop(context,true);
    } else {
      Navigator.pop(context,false);
    };

  }
}