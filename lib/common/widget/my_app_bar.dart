import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ape/util/theme_utils.dart';
import 'package:ape/global/global_router.dart';

/// 自定义 AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  const MyAppBar({
    Key key,
    this.backgroundColor,
    this.title: '',
    this.centerTitle: '',
    this.actionName: '',
    this.backImg: 'assets/images/common/back_arrow_black.png',
    this.onPressed,
    this.isBack: true
  }): super(key: key);

  final Color backgroundColor;
  final String title;
  final String centerTitle;
  final String backImg;
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

    var back = isBack ? IconButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        NavigatorUtils.goBack(context);
      },
      tooltip: '返回',
      padding: const EdgeInsets.all(12.0),
      icon: Image.asset(
        backImg,
        //color: ThemeUtils.getIconColor(context),
      ),
    ) : SizedBox.shrink();

    var action = actionName.isNotEmpty ? Positioned(
      right: 0.0,
      child: Theme(
        data: Theme.of(context).copyWith(
            buttonTheme: ButtonThemeData(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              minWidth: 60.0,
            )
        ),
        child: FlatButton(
          child: Text(actionName, key: const Key('actionName')),
          textColor: Colours.text,
          highlightColor: Colors.transparent,
          onPressed: onPressed,
        ),
      ),
    ) : SizedBox.shrink();

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
