import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:ape/common/animated_switcher.dart';
import 'package:ape/common/widget/my_error_page.dart';
import 'package:ape/common/widget/my_loading_page.dart';

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
                    background: Container(
                      height: 200,
                      color: Colors.yellow,
                      alignment: Alignment.center,
                      child: Text(
                        'hello world',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    title: EmptyAnimatedSwitcher(
                      display: _showTopBtn,
                      child: Text('app title'),
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
        : MyLoadingPage(title: '个人基本信息',);
  }

  // 显示用户基本信息 widget
  Widget _showUserBasicInfo() {
    return Container(

    );
  }
}
