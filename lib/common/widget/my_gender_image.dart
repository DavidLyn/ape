import 'package:flutter/material.dart';

/// 显示性别图标
class MyGenderImage extends StatelessWidget {

  final int gender;

  MyGenderImage({this.gender});

  @override
  Widget build(BuildContext context) {

    if (gender == null || gender == 0) {

      return SizedBox.shrink();

    }

    return Image.asset(
      gender == 1 ? 'assets/images/common/gender_male.webp' : 'assets/images/common/gender_female.png',
      height: 16,
      width: 16,
      fit: BoxFit.fill,
    );
  }
}

