import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ape/global/global_router.dart';

/// 好友管理
class FriendManagement extends StatefulWidget {
  @override
  _FriendManagementState createState() => _FriendManagementState();
}

class _FriendManagementState extends State<FriendManagement> {
  var friends = [1,2,3];

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
                        image: CachedNetworkImageProvider('https://lvlv-oss-001.oss-cn-beijing.aliyuncs.com/4e90e8e6f88f4649a72d110d0266396d.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: Text('呢称'),
                  subtitle: Text('一枚有态度的程序员'),
                  trailing: Icon(Icons.sort),
                ),

                onTap: () {
                  Map<String, String> params = {
                    'uid': '123456',
                  };

                  NavigatorUtils.push(context, GlobalRouter.friendSetting,params: params);
                },
              );

            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: friends.length,
          ),
        ),
        onWillPop: () {
          return Future.value(true);
        },
      ),
    );
  }

}