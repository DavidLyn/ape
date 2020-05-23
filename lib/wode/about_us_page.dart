import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_selection_item.dart';

/// 更改 关于猩猩 页面
class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  var _styles = [FlutterLogoStyle.stacked, FlutterLogoStyle.markOnly, FlutterLogoStyle.horizontal];
  var _colors = [Colors.red, Colors.green, Colors.brown, Colors.blue, Colors.purple, Colors.pink, Colors.amber];
  var _curves = [
    Curves.ease, Curves.easeIn, Curves.easeInOutCubic, Curves.easeInOut,
    Curves.easeInQuad, Curves.easeInCirc, Curves.easeInBack, Curves.easeInOutExpo,
    Curves.easeInToLinear, Curves.easeOutExpo, Curves.easeInOutSine, Curves.easeOutSine,
  ];

  // 取随机颜色
  Color _randomColor() {
    var red = Random.secure().nextInt(255);
    var greed = Random.secure().nextInt(255);
    var blue = Random.secure().nextInt(255);
    return Color.fromARGB(255, red, greed, blue);
  }

  Timer _countdownTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 2s定时器
      _countdownTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        // https://www.jianshu.com/p/e4106b829bff
        if (!mounted) {
          return;
        }
        setState(() {

        });
      });
    });

  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: '关于猩猩',
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50),
          FlutterLogo(
            size: 100.0,
            colors: _colors[Random.secure().nextInt(7)],
            textColor: _randomColor(),
            style: _styles[Random.secure().nextInt(3)],
            curve: _curves[Random.secure().nextInt(12)],
          ),
          SizedBox(height: 10),
          MySelectionItem(
              title: 'Github',
              content: 'Go Star',
              onTap: (){},        // => NavigatorUtils.goWebViewPage(context, 'Flutter Deer', 'https://github.com/simplezhli/flutter_deer')
          ),
        ],
      ),
    );
  }
}