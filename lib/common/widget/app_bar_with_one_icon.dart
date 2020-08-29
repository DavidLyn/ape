import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ape/util/theme_utils.dart';
import 'package:ape/global/global_router.dart';

/// 自定义 AppBar
class AppBarWithOneIcon extends StatelessWidget implements PreferredSizeWidget {

  const AppBarWithOneIcon({
    Key key,
    this.backgroundColor,
    this.title: '',
    this.centerTitle: '',
    this.backImg: 'assets/images/common/back_arrow_black.png',
    this.actionName: '',
    this.actionIcon,
    this.onPressed,
    this.isBack: true
  }): super(key: key);

  final Color backgroundColor;
  final String title;
  final String centerTitle;
  final String backImg;
  final Icon actionIcon;
  final String actionName;
  final VoidCallback onPressed;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    Color _backgroundColor;

    if (backgroundColor == null) {
      _backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    } else {
      _backgroundColor = backgroundColor;
    }

    SystemUiOverlayStyle _overlayStyle = ThemeData.estimateBrightnessForColor(_backgroundColor) == Brightness.dark
        ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    // 构造 back widget
    var back = isBack ? IconButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        NavigatorUtils.goBack(context);
      },
      tooltip: '返回',
      padding: const EdgeInsets.all(12.0),
      icon: Image.asset(
        backImg,
      ),
    ) : SizedBox.shrink();

    // 构造 action icon widget
    var action = actionIcon != null ? Positioned(
      right: 0.0,
      child: IconButton(
        icon: actionIcon,
        onPressed: onPressed,
        tooltip: actionName,
      ),
    ) : SizedBox.shrink();

    // 构造 标题 widget
    var titleWidget = Semantics(
      namesRoute: true,
      header: true,
      child: Container(
        alignment: centerTitle.isEmpty ? Alignment.centerLeft : Alignment.center,
        width: double.infinity,
        child: Text(
          title.isEmpty ? centerTitle : title,
          style: TextStyle(fontSize: 18),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 48.0),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Material(
        color: _backgroundColor,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              titleWidget,
              back,
              action,
            ],
          ),
        ),
      ),
    );

  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}

