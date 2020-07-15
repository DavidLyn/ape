import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/network/rest_result_wrapper.dart';
import 'package:ape/util/log_utils.dart';
import 'package:ape/entity/user.dart';

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
            title: Text('添加吾友'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.add),onPressed: (){
              },),
            ],
          ),
          body: Column(
            children: <Widget>[
              _searchItem(),
            ],
          ),
        ),
        onWillPop: () {
          return Future.value(true);
        },
      ),
    );
  }

  Widget _searchItem() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 10,right: 10,),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color:Colors.grey,width: 1.0,),
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
      return Text('请输入搜索关键字!');
    }

    return FriendSearchByMobile(mobile: query,);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('输入搜索关键字',style: TextStyle(fontSize: 28,color: Colors.grey),),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    var theme = Theme.of(context);
    return super.appBarTheme(context).copyWith(
        primaryColor: theme.scaffoldBackgroundColor,
        primaryColorBrightness: theme.brightness);
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
              fontSize: 32.0,
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
                fontSize: 32.0,
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
                fontSize: 32.0,
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
            trailing: RaisedButton(
              textColor: Colors.green,
              onPressed: (){
                Map<String,String> params = {
                  'friendId': userList[index].uid.toString(),
                  'nickname': userList[index].nickname,
                  'avatar': userList[index].avatar,
                  'profile': userList[index].profile,
                };

                NavigatorUtils.pushWaitingResult(context, GlobalRouter.friendAskFor,(_){
                  // To-do 还想好怎么处理
                }, params:params);

              },
              child: Text('请求加友'),
            ),
          ),

          onTap: () {

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