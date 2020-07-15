import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:ape/global/global_router.dart';
import 'package:ape/entity/friend_entity.dart';
import 'package:ape/provider/friend_provider.dart';

/// 好友管理
class FriendManagement extends StatefulWidget {
  @override
  _FriendManagementState createState() => _FriendManagementState();
}

class _FriendManagementState extends State<FriendManagement> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
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
                        image: CachedNetworkImageProvider(Provider.of<FriendProvider>(context).friends[index].avatar),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: Text(Provider.of<FriendProvider>(context).friends[index].nickname),
                  subtitle: Text(Provider.of<FriendProvider>(context).friends[index].profile),
                  trailing: Icon(Icons.sort),
                ),

                onTap: () {
                  Map<String, String> params = {
                    'uid': Provider.of<FriendProvider>(context).friends[index].friendId.toString(),
                  };

                  NavigatorUtils.push(context, GlobalRouter.friendSetting,params: params);
                },
              );

            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: Provider.of<FriendProvider>(context).friends.length,   //_friends.length,
          ),
        ),
        onWillPop: () {
          return Future.value(true);
        },
      ),
    );
  }

}