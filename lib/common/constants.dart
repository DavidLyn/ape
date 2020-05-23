
/// 保存可能被多个模块引用的 Shared Preference 常量
class SpConstants {

  static const String appTheme = 'appTheme';

  static const openSlash = "openSlash";

  static const phoneNumber = 'phoneNumber';

  static const accessToken = 'accessToken';

  static const accessSalt = 'accessSalt';

  /// 根据电话号码返回相应的 sp key
  static String getMobileSpKey(String mobile) => 'user_mobile_' + mobile.trim();
}

/// 其他常量类型