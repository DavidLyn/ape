import 'package:flutter/material.dart';

import 'package:ape/zixi/zixi_page.dart';
import 'package:ape/xixi/xix_page.dart';
import 'package:ape/wode/wode_page.dart';
import 'package:ape/util/theme_utils.dart';
import 'package:ape/common/widget/loaded_image_widgets.dart';
import 'package:ape/common/widget/double_tap_back_exit_app.dart';

/// Home 页面
///
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  // tab 页 list
  var _pageList = [
    ZixiPage(),
    XixiPage(),
    WodePage()
  ];

  var _appBarTitles = ['自习', '习习',  '我的'];
  final _pageController = PageController();

  List<BottomNavigationBarItem> _list;
  List<BottomNavigationBarItem> _listDark;

  List<BottomNavigationBarItem> _buildBottomNavigationBarItem() {
    if (_list == null) {
      var _tabImages = [
        [
          const LoadedAssetImageWidget('home/zixi', width: 25.0, color: Colours.unselected_item_color,),
          const LoadedAssetImageWidget('home/zixi', width: 25.0, color: Colours.app_main,),
        ],
        [
          const LoadedAssetImageWidget('home/xixi', width: 25.0, color: Colours.unselected_item_color,),
          const LoadedAssetImageWidget('home/xixi', width: 25.0, color: Colours.app_main,),
        ],
        [
          const LoadedAssetImageWidget('home/wode', width: 25.0, color: Colours.unselected_item_color,),
          const LoadedAssetImageWidget('home/wode', width: 25.0, color: Colours.app_main,),
        ]
      ];
      _list = List.generate(_appBarTitles.length, (i) {
        return BottomNavigationBarItem(
            icon: _tabImages[i][0],
            activeIcon: _tabImages[i][1],
            title: Padding(
              padding: const EdgeInsets.only(top: 1.5),
              child: Text(_appBarTitles[i], key: Key(_appBarTitles[i]),),
            )
        );
      });
    }
    return _list;
  }

  List<BottomNavigationBarItem> _buildDarkBottomNavigationBarItem() {
    if (_listDark == null) {
      var _tabImagesDark = [
        [
          const LoadedAssetImageWidget('home/zixi', width: 25.0),
          const LoadedAssetImageWidget('home/zixi', width: 25.0, color: Colours.dark_app_main,),
        ],
        [
          const LoadedAssetImageWidget('home/xixi', width: 25.0),
          const LoadedAssetImageWidget('home/xixi', width: 25.0, color: Colours.dark_app_main,),
        ],
        [
          const LoadedAssetImageWidget('home/wode', width: 25.0),
          const LoadedAssetImageWidget('home/wode', width: 25.0, color: Colours.dark_app_main,),
        ]
      ];

      _listDark = List.generate(_appBarTitles.length, (i) {
        return BottomNavigationBarItem(
            icon: _tabImagesDark[i][0],
            activeIcon: _tabImagesDark[i][1],
            title: Padding(
              padding: const EdgeInsets.only(top: 1.5),
              child: Text(_appBarTitles[i], key: Key(_appBarTitles[i]),),
            )
        );
      });
    }
    return _listDark;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtils.isDark(context);

    return DoubleTapBackExitApp(
      child: Scaffold(
          bottomNavigationBar:  BottomNavigationBar(
              backgroundColor: ThemeUtils.getBackgroundColor(context),
              items: isDark ? _buildDarkBottomNavigationBarItem() : _buildBottomNavigationBarItem(),
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              elevation: 5.0,
              iconSize: 21.0,
              selectedFontSize: 10.0,
              unselectedFontSize: 10.0,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: isDark ? Colours.dark_unselected_item_color : Colours.unselected_item_color,
              onTap: (index) => _pageController.jumpToPage(index),
          ),
          // 使用PageView的原因参看 https://zhuanlan.zhihu.com/p/58582876
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _pageList,
            physics: NeverScrollableScrollPhysics(), // 禁止滑动
          )
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
