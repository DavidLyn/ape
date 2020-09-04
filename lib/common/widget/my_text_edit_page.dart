import 'package:flutter/material.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/util/other_utils.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/network/rest_result_wrapper.dart';
import 'package:ape/util/log_utils.dart';

// MyTextEdit 保存时的回调,如果非空串或 null,则表示文本有错误,不能返回,toast 本回调返回值
//typedef String MyTextEditCallback(String text);

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
  //final MyTextEditCallback callback;
  
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
        backgroundColor: Colors.green,
        centerTitle: widget.title,
        actionName: '保存',
        onPressed: () {
          if (_controller.text.isEmpty) {
            OtherUtils.showToastMessage('<${widget.hintText}>不能为空!');
            return;
          }

          switch (widget.hintText) {
            case '昵称' : {
              _request('nickname');

              break;
            }
            case '个性签名' : {
              _request('profile');

              break;
            }
            default: {

            }
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 21.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Semantics(
          multiline: widget.maxLines > 1,
          maxValueLength: widget.maxLength,
          child: TextField(
            maxLength: widget.maxLength,
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

  void _request(String fieldName) {
    DioManager().request<String>(
        NWMethod.POST,
        NWApi.updateUser,
        data: {'uid': UserInfo.user.uid.toString(),'fieldName': fieldName,'value': _controller.text},
        success: (data,message) {
          Log.d("Update $fieldName success! data = $data");

          NavigatorUtils.goBackWithParams(context, _controller.text);
        },
        error: (error) {
          Log.e("Update $fieldName error! code = ${error.code}, message = ${error.message}");

          OtherUtils.showToastMessage(error.message ?? 'save failed！');
        }
    );
  }

}
