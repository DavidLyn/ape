import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/my_scroll_view.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_text_field.dart';
import 'package:ape/common/widget/my_button.dart';
import 'package:ape/util/other_utils.dart';
import 'package:ape/util/log_utils.dart';
import 'package:ape/entity/user.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/network/rest_result_wrapper.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:flustars/flustars.dart' as flustars;
import 'package:ape/common/constants.dart';

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

    _nameController.text = UserInfo.user.mobile ?? '';
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

    // 如果电话号码与 UserInfo 中的一致,则使用 UserInfo 中的 uid,否则设置为 null
    var userid = _nameController.text == UserInfo.user.mobile ? UserInfo.user.uid : null;

    // 用 salt 存储短信验证码
    var user = User( mobile: _nameController.text,
        password: _passwordController.text,
        salt: _vCodeController.text,
        uid: userid );

    DioManager().request<User>(
        NWMethod.POST,
        NWApi.resetpassword,
        data: user.toJson(),
        success: (data,message) {
          Log.d("Reset password success! data = $data");

          // 将 user 保存到本地
          UserInfo.saveUserToLocal(data);

          OtherUtils.showToastMessage('重置密码成功!');

          // 返回到上级页面
          NavigatorUtils.goBack(context);
        },
        error: (error) {
          Log.e("Reset password error! code = ${error.code}, message = ${error.message}");

          OtherUtils.showToastMessage('重置密码失败!');
        }
    );

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
        getVCode: () async {

          if (_nameController.text.length == 11) {

            // 通过后台向手机发短信
            DioManager().request<String>(
                NWMethod.GET,
                NWApi.sendSms,
                params : <String,dynamic>{'mobile':_nameController.text},
                success: (data,message) {
                  Log.d("Send sms success! data = $data");

                  return true;
                },
                error: (error) {
                  Log.e("Send sms error! code = ${error.code}, message = ${error.message}");

                  OtherUtils.showToastMessage('短信发送失败!');
                  return false;
                }
            );

            return true;
          } else {
            OtherUtils.showToastMessage('请输入有效的手机号');
            return false;
          }
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
