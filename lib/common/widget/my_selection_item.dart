import 'package:flutter/material.dart';
import 'package:ape/common/widget/loaded_image_widgets.dart';

/// setting 页面中使用 功能项 widget
///
class MySelectionItem extends StatefulWidget {

  static const Widget _arrowRight = const LoadedAssetImageWidget(
      'common/arrow_right', height: 16.0, width: 16.0);

  MySelectionItem({
    Key key,
    this.onTap,
    @required this.title,
    this.content: '',
    this.textAlign: TextAlign.start,
    this.maxLines: 1,
    this.icon,
    this.image,
  }) : super(key: key);

  GestureTapCallback onTap;
  String title;
  String content;
  TextAlign textAlign;
  int maxLines;
  Icon icon;
  Widget image;

  @override
  MySelectionItemState createState() => MySelectionItemState();

}

/// 注意:为了实现在外部访问,本状态类被设置为 public
class MySelectionItemState extends State<MySelectionItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  // 修改 content
  void setContent(String content) {
    widget.content = content;
    setState(() {
    });
  }

  void setImage(Widget image) {
    widget.image = image;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15.0),
        padding: const EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
        constraints: BoxConstraints(
            maxHeight: double.infinity,
            minHeight: 50.0
        ),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
              bottom: Divider.createBorderSide(context, width: 0.6),
            )
        ),
        child: Row(
          //为了数字类文字居中
          crossAxisAlignment: widget.maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _LeftComponent(
              icon: widget.icon,
              title: widget.title,
            ),
//            ValueListenableBuilder(
//                valueListenable: widget.redrawNote,
//                builder: (context, value, child) => _RightComponent(
//                  onTap: widget.onTap,
//                  content: widget.content,
//                  textAlign: widget.textAlign,
//                  maxLines: widget.maxLines,
//                  image: widget.image,
//                ),
//            ),
            _RightComponent(
              onTap: widget.onTap,
              content: widget.content,
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
              image: widget.image,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftComponent extends StatelessWidget {

  _LeftComponent({
    Key key,
    this.icon,
    this.title: '',
  }): super(key: key);

  Icon icon;
  String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        icon==null ? SizedBox.shrink() : icon,
        icon==null ? SizedBox.shrink() : SizedBox(width: 10),
        Text(title),
      ],
    );
  }
}

class _RightComponent extends StatelessWidget {

  GestureTapCallback onTap;
  String content;
  TextAlign textAlign;
  int maxLines;
  Widget image;

  _RightComponent({
    Key key,
    this.onTap,
    this.content,
    this.textAlign,
    this.maxLines,
    this.image,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        image != null ? image : SizedBox.shrink(),
        image != null ? SizedBox(width: 10) : SizedBox.shrink(),
        Text(
              content,
              maxLines: maxLines,
              textAlign: maxLines == 1 ? TextAlign.right : textAlign,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14)
          ),
        SizedBox(width: 8),
        Opacity(
          // 无点击事件时，隐藏箭头图标
          opacity: onTap == null ? 0 : 1,
          child: Padding(
            padding: EdgeInsets.only(top: maxLines == 1 ? 0.0 : 2.0),
            child: MySelectionItem._arrowRight,
          ),
        ),
      ],
    );
  }
}
