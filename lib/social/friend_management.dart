import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:ape/global/global_router.dart';
import 'package:ape/provider/friend_provider.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';

/// 好友管理
class FriendManagement extends StatefulWidget {
  @override
  _FriendManagementState createState() => _FriendManagementState();
}

class _FriendManagementState extends State<FriendManagement> {
  TabController mTabcontroller;

  @override
  void initState() {
    super.initState();

    mTabcontroller = TabController(vsync: ScrollableState(), initialIndex: 0, length: 3);
  }

  @override
  void dispose() {

    mTabcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithOneIcon(
        backgroundColor: Colors.green,
        centerTitle: '吾友',
        actionIcon: Icon(Icons.add),
        actionName: '添加',
        onPressed: (){
          NavigatorUtils.push(context, GlobalRouter.friendAdding);
        },
      ),
      body: Container(
        color: Color(0xffeeeeee),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: TabBar(
                tabs: [
                  Tab(
                    text: "吾友",
                  ),
                  Tab(
                    text: "请求",
                  ),
                  Tab(
                    text: "邀约",
                  ),
                ],
                controller: mTabcontroller,
                //配置控制器
                //  isScrollable: true,
                indicatorColor: Colors.deepOrange,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                //indicatorPadding: EdgeInsets.only(bottom: 10.0),
                //labelPadding: EdgeInsets.only(left: 20),
                labelColor: Color(0xff333333),
                labelStyle: TextStyle(
                  fontSize: 16.0,
                ),
                unselectedLabelColor: Color(0xff666666),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: mTabcontroller, //配置控制器
                children: <Widget>[
                  _FriendListPage(),
                  _FriendRequestPage(),
                  _FriendInvitedPage(),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

}

/// 朋友列表页面
class _FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<_FriendListPage> {

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
    return ListView.separated(
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
                  image: CachedNetworkImageProvider(Provider
                      .of<FriendProvider>(context)
                      .friends[index].avatar),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(Provider
                .of<FriendProvider>(context)
                .friends[index].nickname),
            subtitle: Text(Provider
                .of<FriendProvider>(context)
                .friends[index].profile),
            trailing: Icon(Icons.sort),
          ),

          onTap: () {
            Map<String, String> params = {
              'uid': Provider
                  .of<FriendProvider>(context, listen: false)
                  .friends[index].friendId.toString(),
            };

            NavigatorUtils.push(
                context, GlobalRouter.friendSetting, params: params);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: Provider
          .of<FriendProvider>(context)
          .friends
          .length, //_friends.length,
    );
  }

}

/// 请求页面
class _FriendRequestPage extends StatefulWidget {
  @override
  _FriendRequestPageState createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<_FriendRequestPage> {

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
    return ListView.separated(
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
                  image: CachedNetworkImageProvider(Provider
                      .of<FriendProvider>(context)
                      .friendsAskfor[index].avatar),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(Provider
                .of<FriendProvider>(context)
                .friendsAskfor[index].nickname),
            subtitle: Text(Provider
                .of<FriendProvider>(context)
                .friendsAskfor[index].profile),
            trailing: Icon(Icons.sort),
          ),

          onTap: () {
            Map<String, String> params = {
              'uid': Provider
                  .of<FriendProvider>(context, listen: false)
                  .friendsAskfor[index].friendId.toString(),
            };

            NavigatorUtils.push(
                context, GlobalRouter.friendSetting, params: params);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: Provider
          .of<FriendProvider>(context)
          .friendsAskfor
          .length, //friendsAskfor.length,
    );
  }

}

/// 邀约页面
class _FriendInvitedPage extends StatefulWidget {
  @override
  _FriendInvitedPageState createState() => _FriendInvitedPageState();
}

class _FriendInvitedPageState extends State<_FriendInvitedPage> {

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
    return ListView.separated(
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
                  image: CachedNetworkImageProvider(Provider
                      .of<FriendProvider>(context)
                      .friendsInviting[index].avatar),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(Provider
                .of<FriendProvider>(context)
                .friendsInviting[index].nickname),
            subtitle: Text(Provider
                .of<FriendProvider>(context)
                .friendsInviting[index].profile),
            trailing: Icon(Icons.sort),
          ),

          onTap: () {
            Map<String, String> params = {
              'uid': Provider.of<FriendProvider>(context, listen: false).friendsInviting[index].friendId.toString(),
            };

            NavigatorUtils.push(
                context, GlobalRouter.friendSetting, params: params);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: Provider.of<FriendProvider>(context).friendsInviting.length, //friendsInviting.length,
    );
  }

}
