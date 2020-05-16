import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/my_scroll_view.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_text_field.dart';
import 'package:ape/common/widget/my_button.dart';
import 'package:ape/util/other_utils.dart';

/// 重置密码页面
class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  //定义一个controller
  TextEditingController _nameController = TextEditingController();
  TextEditingController _vCodeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  bool _clickable = false;
  
  @override
  void initState() {
    super.initState();
    //监听输入改变  
    _nameController.addListener(_verify);
    _vCodeController.addListener(_verify);
    _passwordController.addListener(_verify);
  }

  void _verify() {
    String name = _nameController.text;
    String vCode = _vCodeController.text;
    String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }
  
  void _reset() {
    OtherUtils.showToastMessage('确认......');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '忘记密码',
      ),
      body: MyScrollView(
        keyboardConfig: OtherUtils.getKeyboardActionsConfig(context, [_nodeText1, _nodeText2, _nodeText3]),
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return [
      const Text(
        '重置登录密码',
        style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 16),
      MyTextField(
        focusNode: _nodeText1,
        controller: _nameController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: '请输入手机号',
      ),
      SizedBox(height: 8),
      MyTextField(
        focusNode: _nodeText2,
        controller: _vCodeController,
        keyboardType: TextInputType.number,
        getVCode: () {
          return Future.value(true);
        },
        maxLength: 6,
        hintText: '请输入验证码',
      ),
      SizedBox(height: 8),
      MyTextField(
        focusNode: _nodeText3,
        isInputPwd: true,
        controller: _passwordController,
        maxLength: 16,
        keyboardType: TextInputType.visiblePassword,
        hintText: '请输入密码',
      ),
      SizedBox(height: 24),
      MyButton(
        onPressed: _clickable ? _reset : null,
        text: '确认',
      )
    ];
  }
}
