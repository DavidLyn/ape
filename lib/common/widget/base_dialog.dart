
import 'package:flutter/material.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/util/theme_utils.dart';

/// 自定义 dialog 的模板
class BaseDialog extends StatelessWidget {

  const BaseDialog({
    Key key,
    this.title,
    this.onPressed,
    this.hiddenTitle : false,
    @required this.child
  }) : super(key : key);

  final String title;
  final Function onPressed;
  final Widget child;
  final bool hiddenTitle;

  @override
  Widget build(BuildContext context) {
    
    var dialogTitle = Visibility(
      visible: !hiddenTitle,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          hiddenTitle ? '' : title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
    
    var bottomButton = Row(
      children: <Widget>[
        _DialogButton(
          text: '取消',
          textColor: Colours.text_gray,
          onPressed: () => NavigatorUtils.goBack(context),
        ),
        const SizedBox(
          height: 48.0,
          width: 0.6,
          child: const VerticalDivider(),
        ),
        _DialogButton(
          text: '确定',
          textColor: Theme.of(context).primaryColor,
          onPressed: onPressed,
        ),
      ],
    );
    
    var body = Material(
      borderRadius: BorderRadius.circular(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 24),
          dialogTitle,
          Flexible(child: child),
          SizedBox(width: 8),
          Divider(),
          bottomButton,
        ],
      ),
    );
    
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInCubic,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: SizedBox(
            width: 270.0,
            child: body,
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  
  const _DialogButton({
    Key key,
    this.text,
    this.textColor,
    this.onPressed,
  }): super(key: key);
  
  final String text;
  final Color textColor;
  final Function onPressed;
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48.0,
        child: FlatButton(
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
          textColor: textColor,
          onPressed: onPressed,
        ),
      ),
    );
  }
}