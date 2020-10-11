import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flustars/flustars.dart' as FlutterStars;
import 'package:ape/common/constants.dart';

/// 创建 头像 widget
class MyAvatar extends StatelessWidget {

  const MyAvatar({
    Key key,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
    this.color,
  }): super(key: key);

  final double width;
  final double height;
  final int cacheWidth;
  final int cacheHeight;
  final BoxFit fit;
  final Color color;

  @override
  Widget build(BuildContext context) {

    var avatarFile = FlutterStars.SpUtil.getString(SpConstants.userAvatar);

    return avatarFile.isEmpty ?
     Image.asset( 'assets/images/common/default_avatar.png',
       width: width,
       height: height,
       cacheWidth: cacheWidth,
       cacheHeight: cacheHeight,
       fit: fit,
       color: color,
       excludeFromSemantics: true,
     )
        : Image.file(File(avatarFile),
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,
      excludeFromSemantics: true,
    );

  }
}