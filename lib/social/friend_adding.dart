import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/network/rest_result_wrapper.dart';
import 'package:ape/util/log_utils.dart';
import 'package:ape/entity/user.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/provider/friend_provider.dart';

enum PageStatus {
  busy,
  error,
  ok,
}

/// 添加好友
class FriendAdding extends StatefulWidget {
  @override
  _FriendAddingState createState() => _FriendAddingState();
}

class _FriendAddingState extends State<FriendAdding> {

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
    return Scaffold(
      appBar: AppBarWithOneIcon(
        backgroundColor: Colors.green,
        centerTitle: '添加吾友',
//        actionIcon: Icon(Icons.add),
//        actionName: '添加',
//        onPressed: (){
//        },
      ),
      body: Column(
        children: <Widget>[
          _searchItem(),
        ],
      ),
    );

  }

  Widget _searchItem() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 5,right: 5,top: 3,),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color:Colors.black12,width: 1.0,),
            color: Colors.white10,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          alignment: Alignment.center,
          height: 36,
          //padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10,),
              Icon(Icons.search),
              SizedBox(width: 15,),
              Text('搜索',style: TextStyle(color: Colors.grey,fontSize: 14),),
            ],
          ),
        ),
      ),
      onTap: () {
        showSearch(context: context, delegate: _SearchFriendDelegate());
      },
    );
  }

}

/// https://mp.weixin.qq.com/s/eSVoyITisYYVqQI65agxxQ
class _SearchFriendDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => '手机号或三省号';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: Text('请输入搜索关键字!',
          style: TextStyle(color: Colors.black38,fontSize: 28),
        ),
      );
    }

    if (query == UserInfo.user.mobile) {
      return Container(
        alignment: Alignment.center,
        child: Text('请输入非本人的手机号!',
          style: TextStyle(color: Colors.black38,fontSize: 20),
        ),
      );
    }

    return FriendSearchByMobile(mobile: query,);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('输入搜索关键字',style: TextStyle(fontSize: 24,color: Colors.black38),),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    var theme = Theme.of(context);
    return super.appBarTheme(context).copyWith(
//        primaryColor: theme.scaffoldBackgroundColor,
        primaryColor: Colors.greenAccent,
        primaryColorBrightness: theme.brightness,
    );
  }

  @override
  void close(BuildContext context, result) {

    super.close(context, result);
  }

}

class FriendSearchByMobile extends StatefulWidget {
  PageStatus status = PageStatus.busy;

  String mobile;

  FriendSearchByMobile({this.mobile});

  @override
  _FriendSearchByMobileState createState() => _FriendSearchByMobileState();
}

class _FriendSearchByMobileState extends State<FriendSearchByMobile> {

  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 从后台查询数据
  void _init() {
    DioManager().request<String>(
        NWMethod.GET,
        NWApi.searchUserByMobileOrName,
        params : <String,dynamic>{'mobile': widget.mobile},
        success: (data,message) {
          Log.d("Search user success! data = $data");

          List list = convert.jsonDecode(data);

          setState(() {
            userList = list.map((json) => User.fromJson(json)).toList();
            widget.status = PageStatus.ok;
          });
        },
        error: (error) {
          Log.e("Send user error! code = ${error.code}, message = ${error.message}");

          setState(() {
            widget.status = PageStatus.error;
          });
        }
    );

  }

  @override
  Widget build(BuildContext context) {

    if (widget.status == PageStatus.busy) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: Colors.green,
          highlightColor: Colors.blue,
          child: Text(
            '正在查询数据......',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        )
      );
    }

    if (widget.status == PageStatus.error) {
      return Center(
          child: Shimmer.fromColors(
            baseColor: Colors.yellow,
            highlightColor: Colors.red,
            child: Text(
              '查询数据出错!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          )
      );
    }

    if (userList == null || userList.length == 0) {
      return Center(
          child: Shimmer.fromColors(
            baseColor: Colors.blue,
            highlightColor: Colors.green,
            child: Text(
              '查询不到数据!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          )
      );

    }

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
                  image: CachedNetworkImageProvider(userList[index].avatar),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(userList[index].nickname),
            subtitle: Text(userList[index].profile),
            ///trailing: Icon(Icons.sort),
            trailing: !Provider.of<FriendProvider>(context,listen: false).isFriend(userList[index].uid) ? RaisedButton(
              textColor: Colors.green,
              onPressed: (){
                Map<String,String> params = {
                  'friendId': userList[index].uid.toString(),
                  'nickname': userList[index].nickname,
                  'avatar': userList[index].avatar,
                  'profile': userList[index].profile,
                  'gender': userList[index].gender.toString(),
                };

                NavigatorUtils.pushWaitingResult(context, GlobalRouter.friendAskFor,(_){
                  // To-do 还想好怎么处理
                }, params:params);

              },
              child: Text('请求加好友'),
            ) : Text('已是好友',style: TextStyle(fontSize: 14,color: Colors.black38),),
          ),
          onTap: () {
            Map<String, String> params = {
              'uid': userList[index].uid.toString(),
            };

            NavigatorUtils.push(context, GlobalRouter.personHome,params: params);

          },
        );

      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: userList.length,
    );
  }

}