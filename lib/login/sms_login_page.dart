import 'package:flutter/material.dart';

import 'package:flustars/flustars.dart' as FlutterStars;
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
import 'package:ape/common/constants.dart';

/// 短信验证登录页面
class SMSLoginPage extends StatefulWidget {
  @override
  _SMSLoginPageState createState() => _SMSLoginPageState();
}

class _SMSLoginPageState extends State<SMSLoginPage> {
  
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;
  
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_verify);
    _vCodeController.addListener(_verify);

    _phoneController.text = UserInfo.user.mobile ?? '';
  }

  void _verify() {
    String name = _phoneController.text;
    String vCode = _vCodeController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _login() {

    // 如果电话号码与 UserInfo 中的一致,则使用 UserInfo 中的 uid,否则设置为 null
    var userid = _phoneController.text == UserInfo.user.mobile ? UserInfo.user.uid : null;

    var user = User( mobile: _phoneController.text,
                     salt: _vCodeController.text,
                     uid: userid );

    DioManager().request<User>(
        NWMethod.POST,
        NWApi.smslogin,
        data: user.toJson(),
        success: (data,message) {
          Log.d("SMS Login success! data = $data");

          // 将 user 保存到本地,拉取头像等, 当 变更号码需重载用户信息
          UserInfo.saveUserToLocal(data, isReload : userid == null);

          // 保存已登录状态
          FlutterStars.SpUtil.putBool(SpConstants.isNotLogin, false);

          // 切换到 home 页面
          NavigatorUtils.push(context, GlobalRouter.home, clearStack: true);
        },
        error: (error) {
          Log.e("SMS Login error! code = ${error.code}, message = ${error.message}");

          OtherUtils.showToastMessage('登录失败!');
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '短信验证登录',
      ),
      body: MyScrollView(
        keyboardConfig: OtherUtils.getKeyboardActionsConfig(context, [_nodeText1, _nodeText2]),
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody(),
      ),
    );
  }
  
  _buildBody() {
    return [
      const Text(
        '验证码登录',
        style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 16),
      MyTextField(
        focusNode: _nodeText1,
        controller: _phoneController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: '请输入手机号',
      ),
      SizedBox(height: 8),
      MyTextField(
        focusNode: _nodeText2,
        controller: _vCodeController,
        maxLength: 6,
        keyboardType: TextInputType.number,
        hintText: '请输入验证码',
        getVCode: () async {
          if (_phoneController.text.length == 11) {

            // 通过后台向手机发短信
            DioManager().request<String>(
                NWMethod.GET,
                NWApi.sendSms,
                params : <String,dynamic>{'mobile':_phoneController.text},
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
      ),
      SizedBox(height: 8),
      Container(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          child: RichText(
            text: TextSpan(
              text: '提示：未注册账号的手机号，请先',
              style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14),
              children: <TextSpan>[
                TextSpan(text: '注册', style: TextStyle(color: Theme.of(context).errorColor)),
                TextSpan(text: '。'),
              ],
            ),
          ),
          onTap: () => NavigatorUtils.push(context, GlobalRouter.register),
        )
      ),
      SizedBox(height: 24),
      MyButton(
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
      )
    ];
  }
}
