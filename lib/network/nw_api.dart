/// 定义基本 Url 和 Rest 接口
///
class NWApi {
  static final baseApi = 'http://192.168.1.101:8080/api/cat';
  //static final baseApi = 'http://172.16.40.36:8080/api/cat';

  // 手机号、密码登录 Post
  static final login = '/user/login';

  // 手机号、短信认证码登录 Post
  static final smslogin = '/user/smslogin';

  // 手机号、密码、短信认证码注册 Post
  static final register = '/user/register';

  // 手机号、密码、短信认证码重置密码 Post
  static final resetpassword = '/user/resetpassword';

  // Get 给手机号发短信 /user/sendSms?mobile=13301133157
  static final sendSms = '/user/sendSms';

  // 上传头像
  static final uploadAvatar = '/user/uploadAvatar';

}