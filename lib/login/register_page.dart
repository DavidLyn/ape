import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/my_scroll_view.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_text_field.dart';
import 'package:ape/common/widget/my_button.dart';
import 'package:ape/util/other_utils.dart';
import 'package:ape/entity/user.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/network/rest_result_wrapper.dart';
import 'package:ape/network/dio_manager.dart';

/// 注册登录
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  
  void _register() {

    // 用 salt 存储短信验证码
    var user = User( mobile: _nameController.text,
                     password: _passwordController.text,
                     salt: _vCodeController.text );

    DioManager().request<User>(
        NWMethod.POST,
        NWApi.register,
        data: user.toJson(),
        success: (data) {
          print("success data = $data");

          // 切换到 home 页面
          NavigatorUtils.push(context, '/home');
        },
        error: (error) {
          print("error code = ${error.code}, massage = ${error.message}");

          OtherUtils.showToastMessage('注册失败!');
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: '注册',
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
        '开启你的账号',
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
        hintText: '请输入手机号',
      ),
      SizedBox(height: 8),
      MyTextField(
        key: const Key('vcode'),
        focusNode: _nodeText2,
        controller: _vCodeController,
        keyboardType: TextInputType.number,
        getVCode: () async {
          if (_nameController.text.length == 11) {
            OtherUtils.showToastMessage('并没有真正发送哦，直接登录吧！');
            /// 一般可以在这里发送真正的请求，请求成功返回true
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
        key: const Key('password'),
        keyName: 'password',
        focusNode: _nodeText3,
        isInputPwd: true,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        maxLength: 16,
        hintText: '请输入密码',
      ),
      SizedBox(height: 24),
      MyButton(
        key: const Key('register'),
        onPressed: _clickable ? _register : null,
        text: '注册',
      )
    ];
  }
}
