import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ape/global/global_router.dart';

import 'package:ape/common/animated_switcher.dart';
import 'package:ape/common/widget/my_error_page.dart';
import 'package:ape/common/widget/my_loading_page.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/network/rest_result_wrapper.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/entity/user_info.dart';

/// 个人主页
class PersonalHomePage extends StatefulWidget {
  @override
  _PersonalHomePageState createState() => _PersonalHomePageState();

  final int uid;

  PersonalHomePage({this.uid});
}

class _PersonalHomePageState extends State<PersonalHomePage> {
  // 控制是否显示 app bar
  ScrollController _scrollController;
  bool _showTopBtn = false;
  double _height = 200.0;

  // 基本信息是否加载
  bool isBasicInfoLoaded = false;

  // 是否出错,比如数据载入失败等
  bool isError = false;
  String errorMsg = '';

  UserInfo userInfo;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset > _height && !_showTopBtn) {
        _showTopBtn = true;
        setState(() {});
      } else if (_scrollController.offset < _height && _showTopBtn) {
        _showTopBtn = false;
        setState(() {});
      }
    });

    // 读取用户基本信息
    _getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (isError) {
      return MyErrorPage(errorMsg: errorMsg,);
    }

    return isBasicInfoLoaded
        ? Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(),
                SliverAppBar(
                  brightness: Brightness.light,
                  backgroundColor: Colors.green,
                  actions: <Widget>[
                    EmptyAnimatedSwitcher(
                      display: _showTopBtn,
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          print('aaaaaaaaaa');
                        },
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: _showUserBasicInfo(),
                    title: EmptyAnimatedSwitcher(
                      display: _showTopBtn,
                      child: Text('个人信息'),
                    ),
                  ),
                  expandedHeight: 200,
                  pinned: true,
                ),
                SliverGrid.count(
                  crossAxisCount: 4,
                  children: List.generate(8, (index) {
                    return Container(
                      color: Colors.primaries[index % Colors.primaries.length],
                      alignment: Alignment.center,
                      child: Text(
                        '$index',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((content, index) {
                    return Container(
                      height: 85,
                      alignment: Alignment.center,
                      color: Colors.primaries[index % Colors.primaries.length],
                      child: Text(
                        '$index',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    );
                  }, childCount: 25),
                ),
              ],
            ),
          )
        : MyLoadingPage(title: '个人信息',);
  }

  // 读取 用户 基本信息
  void _getUserInfo() {
    DioManager().request<UserInfo>(
        NWMethod.GET,
        NWApi.getUserInfo,
        params : <String,dynamic>{'uid': widget.uid},
        success: (data,message) {
          print('Get User Info success! data = $data');

          setState(() {
            userInfo = data;
            isBasicInfoLoaded = true;
          });

        },
        error: (error) {
          print('Get User Info error! code = ${error.code}, message = ${error.message}');

          setState(() {
            isError = true;
            errorMsg = '读取个人信息失败!';
            isBasicInfoLoaded = true;
          });
        }
    );

  }

  // 显示用户基本信息 widget
  Widget _showUserBasicInfo() {
    return Column(
      children: <Widget>[
        Container(
          height: 224,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/common/person_info_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(userInfo.avatar),
                          radius: 33.0,
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      userInfo.nickname,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Map<String, String> params = {
                          'uid': userInfo.uid.toString(),
                        };

                        NavigatorUtils.push(context, GlobalRouter.personFollow,params: params);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 30,),
                        child: Text(
                          '关注:' + userInfo.followNumber.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Map<String, String> params = {
                          'uid': userInfo.uid.toString(),
                        };

                        NavigatorUtils.push(context, GlobalRouter.personFan,params: params);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 30,),
                        child: Text(
                          '粉丝:' + userInfo.fanNumber.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 10,),
                child: Text(
                  '简介:' + userInfo.profile,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
