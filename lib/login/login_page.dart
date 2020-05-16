import 'package:flutter/material.dart';

import 'package:flustars/flustars.dart' as FlutterStars;

import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/my_scroll_view.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_text_field.dart';
import 'package:ape/common/widget/my_button.dart';
import 'package:ape/util/other_utils.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  static const String phoneNumber = 'phoneNumber';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;

  @override
  void initState() {
    super.initState();
    //监听输入改变
    _nameController.addListener(_verify);
    _passwordController.addListener(_verify);
    _nameController.text = FlutterStars.SpUtil.getString(phoneNumber);
  }

  void _verify() {
    String name = _nameController.text;
    String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }

    /// 状态不一样在刷新，避免重复不必要的setState
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _login() {
    FlutterStars.SpUtil.putString(phoneNumber, _nameController.text);
    NavigatorUtils.push(context, '/store/audit');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        isBack: false,
        actionName: '验证码登录',
        onPressed: () {
          NavigatorUtils.push(context, '/login/smsLogin');
        },
      ),
      body: MyScrollView(
        keyboardConfig: OtherUtils.getKeyboardActionsConfig(context, [_nodeText1, _nodeText2]),
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody,
      ),
    );
  }

  get _buildBody => [
    const Text(
      '密码登录',
      style: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.bold
      ),
    ),
    SizedBox(height: 16),
    MyTextField(
      key: const Key('phone'),
      focusNode: _nodeText1,
      controller: _nameController,
      maxLength: 11,
      keyboardType: TextInputType.phone,
      hintText: '请输入账号',
    ),
    SizedBox(height: 8),
    MyTextField(
      key: const Key('password'),
      keyName: 'password',
      focusNode: _nodeText2,
      isInputPwd: true,
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      maxLength: 16,
      hintText: '请输入密码',
    ),
    SizedBox(height: 24),
    MyButton(
      key: const Key('login'),
      onPressed: _clickable ? _login : null,
      text: '登录',
    ),
    Container(
      height: 40.0,
      alignment: Alignment.centerRight,
      child: GestureDetector(
        child: Text(
          '忘记密码',
          style: Theme.of(context).textTheme.subtitle,
        ),
        onTap: () => NavigatorUtils.push(context, '/login/resetPassword'),
      ),
    ),
    SizedBox(height: 16),
    Container(
        alignment: Alignment.center,
        child: GestureDetector(
          child: Text(
            '还没账号？快去注册',
            style: TextStyle(
                color: Theme.of(context).primaryColor
            ),
          ),
          onTap: () => NavigatorUtils.push(context, '/login/register'),
        )
    )
  ];

}
