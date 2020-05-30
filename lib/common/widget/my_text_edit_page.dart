import 'package:flutter/material.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/my_app_bar.dart';

/// 通用文本编辑 page
class MyTextEditPage extends StatefulWidget {

  const MyTextEditPage({
    Key key,
    @required this.title,
    this.content,
    this.hintText,
    this.maxLines : 1,
    this.maxLength : 20,
    this.keyboardType: TextInputType.text,
  }) : super(key : key);

  final String title;
  final String content;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  
  @override
  _MyTextEditPageState createState() => _MyTextEditPageState();
}

class _MyTextEditPageState extends State<MyTextEditPage> {

  TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _controller.text = widget.content;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.title,
        actionName: '完成',
        onPressed: () {
          NavigatorUtils.goBackWithParams(context, _controller.text);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 21.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Semantics(
          multiline: widget.maxLines > 1,
          maxValueLength: widget.maxLength,
          child: TextField(
            maxLength: 30,
            maxLines: widget.maxLines,
            autofocus: true,
            controller: _controller,
            keyboardType: widget.keyboardType,
            //style: TextStyles.textDark14,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              //hintStyle: TextStyles.textGrayC14
            )
          ),
        ),
      ),
    );
  }
}
