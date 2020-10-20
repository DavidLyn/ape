/// 定义基本 Url 和 Rest 接口
///
class NWApi {
//    static final baseApi = 'http://192.168.1.101:8080/api/cat';
    static final baseApi = 'http://39.107.140.193:8080/api/cat';
//  static final baseApi = 'http://172.16.40.36:8080/api/cat';

  // ------------------------- 用户注册、登录、退出登录相关 ---------------------------------
  // 手机号、密码登录 Post
  static final login = '/user/login';

  // 退出登录
  static final logout = '/user/logout';

  // 手机号、短信认证码登录 Post
  static final smslogin = '/user/smslogin';

  // 手机号、密码、短信认证码注册 Post
  static final register = '/user/register';

  // 手机号、密码、短信认证码重置密码 Post
  static final resetpassword = '/user/resetpassword';

  // Get 给手机号发短信 /user/sendSms?mobile=13301133157
  static final sendSms = '/user/sendSms';

  // Post 修改用户基本信息
  static final updateUser = '/user/update';

  // 上传头像
  static final uploadAvatar = '/user/uploadAvatar';

  // 搜索用户
  static final searchUserByMobileOrName = '/user/searchByMobileOrName';

  // 重载用户信息
  static final reloadFriends = '/user/reloadFriends';

  // ------------------------------ 社交(好友)相关 ------------------------------------
  // 获取用户基本信息
  static final getUserInfo = '/social/userInfo';

  // 修改与好友的关系
  static final updateFriendRelation = '/social/updateRelation';

  // 删除/拉黑 好友
  static final deleteFriend = '/social/deleteFriend';

  // ------------------------------ 社交(群组)相关 ------------------------------------
  // 创建新群组
  static final createGroup = '/group/createGroup';

}