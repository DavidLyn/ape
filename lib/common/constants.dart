
/// 保存可能被多个模块引用的 Shared Preference 常量
class SpConstants {

  // 当前 亮度模式 ，sysrem dark light
  static const String appTheme = 'appTheme';

  //
  static const openSplash = "openSplash";

  // 当前用户的电话号码
  static const phoneNumber = 'phoneNumber';

  // 当前用户的 jwt token
  static const accessToken = 'accessToken';

  // 当前用户的 salt
  static const accessSalt = 'accessSalt';

  /// 根据电话号码返回相应的 sp key，该 key 存储这个电话号码对应的 userid
  static String getMobileSpKey(String mobile) => 'user_mobile_' + mobile.trim();
}

/// 其他常量类型