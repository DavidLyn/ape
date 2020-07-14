import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ape/global/global_router.dart';
import 'package:ape/entity/friend_entity.dart';

/// 好友管理
class FriendManagement extends StatefulWidget {
  @override
  _FriendManagementState createState() => _FriendManagementState();
}

class _FriendManagementState extends State<FriendManagement> {

  List<FriendEntity> _friends = List<FriendEntity>();

  @override
  void initState() {
    super.initState();

    _getFriends();
  }

  @override
  void dispose() {

    super.dispose();
  }

  _getFriends() async {

    _friends = await FriendEntity.getFriendList();

    setState(() {
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            textTheme: TextTheme(title: TextStyle(color: Colors.black,fontSize: 18)),
            leading: BackButton(),
            title: Text('吾友'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.add),onPressed: (){
                NavigatorUtils.push(context, GlobalRouter.friendAdding);
              },),
            ],
          ),
          body: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: ListTile(
                  leading: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(_friends[index].avatar),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: Text(_friends[index].nickname),
                  subtitle: Text(_friends[index].profile),
                  trailing: Icon(Icons.sort),
                ),

                onTap: () {
                  Map<String, String> params = {
                    'uid': _friends[index].friendId.toString(),
                  };

                  NavigatorUtils.push(context, GlobalRouter.friendSetting,params: params);
                },
              );

            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: _friends.length,
          ),
        ),
        onWillPop: () {
          return Future.value(true);
        },
      ),
    );
  }

}