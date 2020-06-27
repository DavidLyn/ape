import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flustars/flustars.dart';
import 'package:ape/common/widget/loaded_image_widgets.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/common/constants.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  // 状态为 0 时显示 logo，状态为 1 时显示 splash
  int _status = 0;

  // splash 图片名数组
  List<String> _guideList = ['app_start_1', 'app_start_2', 'app_start_3'];

  @override
  void initState() {
    super.initState();

    // Frame build 结束回调下述方法
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (SpUtil.getBool(SpConstants.isNotLogin, defValue: true)) {
        /// 预先缓存图片，避免直接使用时因为首次加载造成闪动
        _guideList.forEach((image) {
          precacheImage(ImageUtils.getAssetImageProvider(image,path : 'assets/images/splash'), context);
        });
      }

      // 延时 1500 毫秒后或显示 splash 或跳转至 Home 页面
      Future.delayed(Duration(milliseconds: 1500),(){
        if (SpUtil.getBool(SpConstants.isNotLogin, defValue: true)) {

          setState(() {
            _status = 1;    // 设置为 splash 显示状态
          });

        } else {
          NavigatorUtils.push(context, GlobalRouter.home, replace: true);
        }

      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _status == 0 ? FractionallyAlignedSizedBox(
            heightFactor: 0.33,
            widthFactor: 0.33,
            leftFactor: 0.33,
            bottomFactor: 0.1,
            child: const LoadedImageWidget('logo', path: 'assets/images/logo',)
        ) :
        Swiper(
          key: const Key('swiper'),
          itemCount: _guideList.length,
          loop: false,
          itemBuilder: (_, index) {
            return LoadedImageWidget(
              _guideList[index],
              key: Key(_guideList[index]),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              path: 'assets/images/splash',
            );
          },
          onTap: (index) {
            if (index == _guideList.length - 1) {
              NavigatorUtils.push(context, GlobalRouter.login, replace: true);
            }
          },
        )
    );

  }
}
