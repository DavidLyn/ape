import 'package:flustars/flustars.dart' as flutter_stars;
import 'package:ape/entity/user.dart';

/// 保存可能被多个模块引用的 Shared Preference 常量
class SpConstants {

  // 键盘高度
  static const String keyboardHeight = 'keyboardHeight';

  // 当前 亮度模式 ，system dark light
  static const String appTheme = 'appTheme';

  // 是否已启动 splash
  static const openSplash = "openSplash";

  // 用户头像文件名
  static const userAvatar = 'userAvatar';

}

/// 当前用户信息
class UserInfo {

  static User user;

  static void init() {
    if (user == null) {
      user = getLocalUser();
    }
  }

  static User getLocalUser() {

    User user = User();

    user.uid = flutter_stars.SpUtil.getInt('sp_uid');
    user.name = flutter_stars.SpUtil.getString('sp_name');
    user.nickname = flutter_stars.SpUtil.getString('sp_nickname');
    user.birthday = flutter_stars.SpUtil.getString('sp_birthday');
    user.mobile = flutter_stars.SpUtil.getString('sp_mobile');
    user.email = flutter_stars.SpUtil.getString('sp_email');
    user.password = flutter_stars.SpUtil.getString('sp_password');
    user.salt = flutter_stars.SpUtil.getString('sp_salt');
    user.avatar = flutter_stars.SpUtil.getString('sp_avatar');

    try {
      user.createAt =
          DateTime.parse(flutter_stars.SpUtil.getString('sp_createAt'));
    } catch (e) {
      user.createAt = null;
    }

    try {
      user.updateAt =
          DateTime.parse(flutter_stars.SpUtil.getString('sp_updateAt'));
    } catch (e) {
      user.updateAt = null;
    }

    user.status = flutter_stars.SpUtil.getInt('sp_status');
    user.gender = flutter_stars.SpUtil.getInt('sp_gender');
    user.profile = flutter_stars.SpUtil.getString('sp_profile');

    return user;

  }

  static void saveUserToLocal(User user) {

    UserInfo.user = user;

    flutter_stars.SpUtil.putInt('sp_uid',user.uid);
    flutter_stars.SpUtil.putString('sp_name',user.name);
    flutter_stars.SpUtil.putString('sp_nickname',user.nickname);
    flutter_stars.SpUtil.putString('sp_birthday',user.birthday);
    flutter_stars.SpUtil.putString('sp_mobile',user.mobile);
    flutter_stars.SpUtil.putString('sp_email',user.email);
    flutter_stars.SpUtil.putString('sp_password',user.password);
    flutter_stars.SpUtil.putString('sp_salt',user.salt);
    flutter_stars.SpUtil.putString('sp_avatar',user.avatar);
    flutter_stars.SpUtil.putString('sp_createAt',user.createAt.toString());
    flutter_stars.SpUtil.putString('sp_createAt',user.updateAt.toString());
    flutter_stars.SpUtil.putInt('sp_status',user.status);
    flutter_stars.SpUtil.putInt('sp_gender',user.gender);
    flutter_stars.SpUtil.putString('sp_profile',user.profile);
  }

  static void setNickname(String nickname) {
    user.nickname = nickname;
    flutter_stars.SpUtil.putString('sp_nickname',user.nickname);
  }

  static void setBirthday(String birthday) {
    user.birthday = birthday;
    flutter_stars.SpUtil.putString('sp_birthday',user.birthday);
  }

  static void setGender(int gender) {
    user.gender = gender;
    flutter_stars.SpUtil.putInt('sp_gender',user.gender);
  }

  static void setProfile(String profile) {
    user.profile = profile;
    flutter_stars.SpUtil.putString('sp_profile',user.profile);
  }

  static void setAvatar(String avatar) {
    user.avatar = avatar;
    flutter_stars.SpUtil.putString('sp_avatar',user.avatar);
  }

}