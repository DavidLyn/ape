import 'package:flutter/material.dart';

import 'package:flustars/flustars.dart' as FlutterStars;

import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/my_scroll_view.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_text_field.dart';
import 'package:ape/common/widget/my_button.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/util/other_utils.dart';
import 'package:ape/util/log_utils.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/entity/user.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/network/rest_result_wrapper.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
    _nameController.text = UserInfo.user.mobile ?? '';
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

    // 如果电话号码与 UserInfo 中的一致,则使用 UserInfo 中的 uid,否则设置为 null
    var userid = _nameController.text == UserInfo.user.mobile ? UserInfo.user.uid : null;

    var user = User( mobile: _nameController.text,
                     password: _passwordController.text,
                     uid: userid);

    DioManager().request<User>(
      NWMethod.POST,
      NWApi.login,
      data : user.toJson(),
      success: (data,message) {
        Log.d("Login success! user = $data");

        // 将 user 保存到本地,拉取头像等, 当 变更号码需重载用户信息
        UserInfo.saveUserToLocal(data, isReload : userid == null);

        // 保存已登录状态
        FlutterStars.SpUtil.putBool(SpConstants.isNotLogin, false);

        // 切换到 home 页面
        NavigatorUtils.push(context, GlobalRouter.home, clearStack: true);
      },
      error: (error) {
        Log.e("Login error! code = ${error.code}, message = ${error.message}");

        OtherUtils.showToastMessage('登录失败!');
      }
    );

  }

  @override
  Widget build(BuildContext context) {
    // 获取并保存键盘高度
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (keyboardHeight != 0) {
      print("键盘高度是:" + keyboardHeight.toString());
      FlutterStars.SpUtil.putDouble(SpConstants.keyboardHeight, keyboardHeight);
    }

    return Scaffold(
      appBar: MyAppBar(
        isBack: false,
        actionName: '验证码登录',
        onPressed: () {
          NavigatorUtils.push(context, GlobalRouter.smsLogin);
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
        onTap: () => NavigatorUtils.push(context, GlobalRouter.resetPassword),
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
          onTap: () => NavigatorUtils.push(context, GlobalRouter.register),
        )
    )
  ];

}
