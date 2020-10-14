import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:ape/global/global_router.dart';
import 'package:ape/provider/friend_provider.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';
import 'package:ape/entity/friend_inviting_entity.dart';
import 'package:ape/entity/friend_askfor_entity.dart';
import 'package:ape/entity/friend_entity.dart';
import 'package:ape/util/timeline_utils.dart';
import 'package:ape/common/widget/my_gender_image.dart';

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

/// --------------------------------------------- 朋友列表页面
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
            child: _createItem(context, index),

          onTap: () {
            Map<String, String> params = {
              'relation': Provider.of<FriendProvider>(context, listen: false).friends[index].relation ?? '',
            };

            NavigatorUtils.pushWaitingResult(
                context,
                GlobalRouter.friendSetRelation,
                (result){
                  List<String> list = result;
                  var friend = Provider.of<FriendProvider>(context, listen: false).friends[index];
                  Provider.of<FriendProvider>(context, listen: false).modifyRelation(friend, json.encode(list));
                },
                params: params);
//            NavigatorUtils.push(
//                context, GlobalRouter.friendSetting, params: params);
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

  // 创建 朋友 记录
  Widget _createItem(BuildContext context, int index) {
    var friendEntity = Provider.of<FriendProvider>(context).friends[index];

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 条目间的分隔区域
          Container(
            //margin: EdgeInsets.only(top:  10),
            height: 5,
            color: Color(0xffEFEFEF),
          ),
          _title(context, friendEntity, index),
          _bottom(context, friendEntity),
        ],

      ),
    );
  }

  // 标题
  Widget _title(BuildContext context, FriendEntity friendEntity, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              // --- 头像
              InkWell(
                onTap: (){
                  Map<String, String> params = {
                    'uid': friendEntity.friendId.toString(),
                  };

                  NavigatorUtils.push(context, GlobalRouter.personHome,params: params);
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(friendEntity.avatar),
                        fit: BoxFit.fill,
                      )
                  ),
                ),
              ),

              // --- nickname
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                    child: Text(
                      friendEntity.nickname,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xffF86119),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(6.0, 2.0, 0.0, 0.0),
                    child: Text(
                      friendEntity.profile,
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xff808080),
                      ),
                    ),
                  ),
                ],
              ),

              // --- 性别图像
              MyGenderImage(gender : friendEntity.gender),
            ],
          ),

          // --- button
          friendEntity.state == 1 ?  Container(
            alignment: FractionalOffset.centerRight,
            child: GestureDetector(
              onTap: () {
                Provider.of<FriendProvider>(context,listen: false).blacklistFriend(friendEntity);
              },
              child: Container(
                padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 4.0, right: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text('拉黑',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  // 结尾
  Widget _bottom(BuildContext context, FriendEntity friendEntity) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // --- 时间
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              _getTimeInfo(friendEntity),
              style: TextStyle(
                //color: Colors.green,
                fontSize: 10,
              ),
            ),
          ),

          // --- 删除
          GestureDetector(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context){
                  return CupertinoAlertDialog(
                    title: Text('提示'),
                    content: Text('确认删除吗?'),
                    actions: <Widget>[
                      CupertinoDialogAction(child: Text('取消'),onPressed: (){
                        Navigator.pop(context);
                      },),
                      CupertinoDialogAction(child: Text('确认'),onPressed: () async {
                        await Provider.of<FriendProvider>(context,listen: false).deleteFriend(friendEntity);
                        Navigator.pop(context);
                      },),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete_sweep,
                color: Colors.grey,
              ),
            ),
          ),

        ],
      ),
    );
  }

  // 获取 时间 信息
  String _getTimeInfo(FriendEntity friendEntity) {

    switch (friendEntity.state) {
      case 0 : {
        return TimelineUtils.formatByDatetime(friendEntity.rejectTime, DateTime.now()) + ' 拉黑';
      }
      case 1 : {
        return TimelineUtils.formatByDatetime(friendEntity.friendTime, DateTime.now()) + ' 成为好友';
      }
      default :
        return 'none';
    }
  }

}

/// --------------------------------------------- 请求页面
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
        return _createItem(context, index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: Provider.of<FriendProvider>(context).friendsAskfor.length, //friendsAskfor.length,
    );
  }

  // 创建 请求 记录
  Widget _createItem(BuildContext context, int index) {
    var askforEntity = Provider.of<FriendProvider>(context).friendsAskfor[index];

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 条目间的分隔区域
          Container(
            //margin: EdgeInsets.only(top:  10),
            height: 5,
            color: Color(0xffEFEFEF),
          ),
          _title(context, askforEntity, index),
          _content(context, askforEntity),
          _bottom(context, askforEntity),
        ],

      ),
    );
  }

  // 标题
  Widget _title(BuildContext context, FriendAskforEntity askforEntity, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              // --- 头像
              InkWell(
                onTap: (){
                  Map<String, String> params = {
                    'uid': askforEntity.friendId.toString(),
                  };

                  NavigatorUtils.push(context, GlobalRouter.personHome,params: params);
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(askforEntity.avatar),
                        fit: BoxFit.fill,
                      )
                  ),
                ),
              ),

              // --- nickname
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                    child: Text(
                      askforEntity.nickname,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xffF86119),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(6.0, 2.0, 0.0, 0.0),
                    child: Text(
                      askforEntity.profile,
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xff808080),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),

          // --- button
          SizedBox.shrink(),
        ],
      ),
    );
  }

  // 内容
  Widget _content(BuildContext context, FriendAskforEntity askforEntity) {
    return Container(
      alignment: FractionalOffset.centerLeft,
      margin: EdgeInsets.only(top: 5.0, left: 15, right: 15, bottom: 5),
      child: Text(
        askforEntity.leavingWords,
        style: TextStyle(fontSize: 15,),
      ),
    );
  }

  // 结尾
  Widget _bottom(BuildContext context, FriendAskforEntity askforEntity) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // --- 时间
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              _getTimeInfo(askforEntity),
              style: TextStyle(
                //color: Colors.green,
                fontSize: 10,
              ),
            ),
          ),

          // --- 删除
          GestureDetector(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context){
                  return CupertinoAlertDialog(
                    title: Text('提示'),
                    content: Text('确认删除吗?'),
                    actions: <Widget>[
                      CupertinoDialogAction(child: Text('取消'),onPressed: (){
                        Navigator.pop(context);
                      },),
                      CupertinoDialogAction(child: Text('确认'),onPressed: () async {
                        await Provider.of<FriendProvider>(context,listen: false).deleteAskfor(askforEntity);
                        Navigator.pop(context);
                      },),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete_sweep,
                color: Colors.grey,
              ),
            ),
          ),

        ],
      ),
    );
  }

  // 获取 时间 信息
  String _getTimeInfo(FriendAskforEntity askforEntity) {

    switch (askforEntity.state) {
      case 0 : {
        return TimelineUtils.formatByDatetime(askforEntity.askforTime, DateTime.now()) + ' 请求';
      }
      case 1 : {
        return TimelineUtils.formatByDatetime(askforEntity.responseTime, DateTime.now()) + ' 被接受';
      }
      case 2 : {
        return TimelineUtils.formatByDatetime(askforEntity.responseTime, DateTime.now()) + ' 被拒绝';
      }
      default :
        return 'none';
    }
  }

}

/// --------------------------------------------- 邀约页面
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
        return _createItem(context, index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: Provider.of<FriendProvider>(context).friendsInviting.length, //friendsInviting.length,
    );
  }

  // 创建 邀约 记录
  Widget _createItem(BuildContext context, int index) {
    var invitingEntity = Provider.of<FriendProvider>(context).friendsInviting[index];

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 条目间的分隔区域
          Container(
            //margin: EdgeInsets.only(top:  10),
            height: 5,
            color: Color(0xffEFEFEF),
          ),
          _title(context, invitingEntity, index),
          _content(context, invitingEntity),
          _bottom(context, invitingEntity),
        ],

      ),
    );
  }

  // 标题
  Widget _title(BuildContext context, FriendInvitingEntity invitingEntity, int index) {
      return Container(
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                // --- 头像
                InkWell(
                  onTap: (){
                    Map<String, String> params = {
                      'uid': invitingEntity.friendId.toString(),
                    };

                    NavigatorUtils.push(context, GlobalRouter.personHome,params: params);
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(invitingEntity.avatar),
                          fit: BoxFit.fill,
                        )
                    ),
                  ),
                ),

                // --- nickname
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                      child: Text(
                        invitingEntity.nickname,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xffF86119),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(6.0, 2.0, 0.0, 0.0),
                      child: Text(
                        invitingEntity.profile,
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xff808080),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),

            // --- button
            invitingEntity.state == 0 ?  Container(
              alignment: FractionalOffset.centerRight,
              child: GestureDetector(
                onTap: () async {
                  var result = await showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Text('接受'),
                            onPressed: () {
                              Navigator.of(context).pop(1);
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text('拒绝'),
                            onPressed: () {
                              Navigator.of(context).pop(2);
                            },
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('取消'),
                          onPressed: () {
                            Navigator.of(context).pop(9);
                          },
                        ),
                      );
                    },
                  );

                  switch (result) {
                    case 1 : {    // 接受
                      Provider.of<FriendProvider>(context,listen: false).acceptInviting(index);
                      break;
                    }
                    case 2 : {    // 拒绝
                      Provider.of<FriendProvider>(context,listen: false).rejectInviting(index);
                      break;
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 4.0, right: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text('处理',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
      );
  }

  // 内容
  Widget _content(BuildContext context, FriendInvitingEntity invitingEntity) {
    return Container(
      alignment: FractionalOffset.centerLeft,
      margin: EdgeInsets.only(top: 5.0, left: 15, right: 15, bottom: 5),
      child: Text(
        invitingEntity.leavingWords,
        style: TextStyle(fontSize: 15,),
      ),
    );
  }

  // 结尾
  Widget _bottom(BuildContext context, FriendInvitingEntity invitingEntity) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // --- 时间
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              _getTimeInfo(invitingEntity),
              style: TextStyle(
                //color: Colors.green,
                fontSize: 10,
              ),
            ),
          ),

          // --- 删除
          GestureDetector(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context){
                  return CupertinoAlertDialog(
                    title: Text('提示'),
                    content: Text('确认删除吗?'),
                    actions: <Widget>[
                      CupertinoDialogAction(child: Text('取消'),onPressed: (){
                        Navigator.pop(context);
                      },),
                      CupertinoDialogAction(child: Text('确认'),onPressed: () async {
                        await Provider.of<FriendProvider>(context,listen: false).deleteInviting(invitingEntity);
                        Navigator.pop(context);
                      },),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete_sweep,
                color: Colors.grey,
              ),
            ),
          ),

        ],
      ),
    );
  }

  // 获取 时间 信息
  String _getTimeInfo(FriendInvitingEntity invitingEntity) {

    switch (invitingEntity.state) {
      case 0 : {
        return TimelineUtils.formatByDatetime(invitingEntity.recieveTime, DateTime.now()) + ' 收到';
      }
      case 1 : {
        return TimelineUtils.formatByDatetime(invitingEntity.dealTime, DateTime.now()) + ' 接受';
      }
      case 2 : {
        return TimelineUtils.formatByDatetime(invitingEntity.dealTime, DateTime.now()) + ' 拒绝';
      }
      default :
        return 'none';
    }
  }

}
