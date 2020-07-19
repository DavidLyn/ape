import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:ape/mqtt/mqtt_message.dart';
import 'package:ape/mqtt/mqtt_provider.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/entity/friend_entity.dart';
import 'package:ape/provider/friend_provider.dart';

/// 发出加好友请求
class FriendAskFor extends StatefulWidget {

  final int friendId;
  final String nickname;
  final String avatar;
  final String profile;

  FriendAskFor({this.friendId,this.nickname,this.avatar,this.profile,});

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(title: TextStyle(color: Colors.black,fontSize: 18)),
          leading: BackButton(),
          title: Text('加友请求'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.send),onPressed: (){
              _sendAskFor(context);
            },),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(left: 10,right: 10),
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

    Map<String,String> map = {'friendId':widget.friendId.toString(),
      'leavingWords':_controller.text};

    message.payload = jsonEncode(map);

    if (MQTTProvider.publish(message: jsonEncode(message))) {
      // 向 Friend 表写入记录
      var friend = FriendEntity();
      friend.uid = UserInfo.user.uid;
      friend.friendId = widget.friendId;
      friend.nickname = widget.nickname;
      friend.avatar = widget.avatar;
      friend.profile = widget.profile;
      friend.isValid = 1;
      friend.state = 0;           // Todo  需要修改

      // 注意:修改 Provider 数据 listen 为 false
      Provider.of<FriendProvider>(context,listen: false).addFriend(friend);

      Navigator.pop(context,true);
    } else {
      Navigator.pop(context,false);
    };

  }
}