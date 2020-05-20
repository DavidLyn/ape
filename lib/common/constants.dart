
/// 保存可能被多个模块引用的 Shared Preference 常量
class SpConstants {
  static const String phoneNumber = 'phoneNumber';

  static final accessToken = 'accessToken';

  static final accessSalt = 'accessSalt';

  /// 根据电话号码返回相应的 sp key
  static String getMobileSpKey(String mobile) => 'user_mobile_' + mobile.trim();
}

/// 其他常量类型