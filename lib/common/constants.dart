import 'package:flustars/flustars.dart' as flutter_stars;
import 'dart:math';
import 'package:provider/provider.dart';

import 'package:ape/main.dart';
import 'package:ape/entity/user.dart';
import 'package:ape/util/file_utils.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/common/sqlite_manager.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/network/rest_result_wrapper.dart';
import 'package:ape/util/other_utils.dart';
import 'package:ape/util/log_utils.dart';
import 'package:ape/entity/friend_entity.dart';
import 'package:ape/provider/friend_provider.dart';
import 'package:ape/mqtt/mqtt_provider.dart';

/// 保存可能被多个模块引用的 Shared Preference 常量
class SpConstants {

  // 键盘高度
  static const String keyboardHeight = 'keyboardHeight';

  // 当前 亮度模式 ，system dark light
  static const String appTheme = 'appTheme';

  // 是否已 login
  static const isNotLogin = "isNotLogin";

  // 用户头像文件名
  static const userAvatar = 'userAvatar';

}

/// 当前用户信息 - main 启动时将读取当前用户信息
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

  /// 用户重新登录(login or smsLogin)后调用本方法设置本地信息
  static void saveUserToLocal(User user, {bool isReload : false}) async {

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

    // 读取当前用户的 avatar 文件到本地
    if (user.avatar == null || user.avatar.isEmpty) {
      flutter_stars.SpUtil.putString(SpConstants.userAvatar, '');
    } else {
      // 删除原有头像文件
      var oldFile = flutter_stars.SpUtil.getString(SpConstants.userAvatar);

      if (oldFile.isNotEmpty) {
        ApplicationDocumentManager.deleteFile(oldFile);
      }

      // 分解文件名和后缀名
      String path = user.avatar;
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

      // 注意:此处需要换一下文件名,不然可能是缓存的原因 MyAvatar 的图片不会更换
      var num = Random().nextInt(1000);
      var newFile = '${ApplicationDocumentManager.documentsPath}/avatar$num.$suffix';

      // 下载头像文件
      if (await DioManager().downloadFile(path, newFile)) {
        // 记录新头像文件名
        flutter_stars.SpUtil.putString(SpConstants.userAvatar, newFile);
        print('Set avatar file ok : $newFile');
      } else {
        flutter_stars.SpUtil.putString(SpConstants.userAvatar, '');
      };
    }

    // 根据需要重载当前用户相关信息至本地
    if (isReload) {
      // 删除本地数据表信息, 将来需扩展 ......
      //await DbManager.db.execute('delete from FriendAskfor');
      //await DbManager.db.execute('delete from FriendInviting');
      await DbManager.db.execute('delete from Friend');

      // 从后台拉取当前用户相关信息并保存
      await DioManager().request<List<dynamic>>(
          NWMethod.GET,
          NWApi.reloadFriends,
          params : <String,dynamic>{'uid':user.uid},
          success: (data,message) {
            Log.d("Reload friends success!");

            if (data.length > 0) {
              for (Map<String,dynamic> obj in data) {
                print('obj = $obj');

                FriendEntity friend = FriendEntity();
                friend.uid = obj['uid'];
                friend.friendId = obj['friendId'];
                friend.nickname = obj['nickname'];
                friend.profile = obj['profile'];
                friend.gender = obj['gender'];
                friend.state = obj['state'];
                friend.relation = obj['relation'];
                friend.avatar = obj['avatar'];
                friend.friendTime = DateTime.parse(obj['friendTime']);

                if (obj.containsKey("deleteTime")) {
                  friend.deleteTime = DateTime.parse(obj['deleteTime']);
                }

                FriendEntity.insert(friend);
              }

            }

            // 重新装载缓存中的 好友 信息
            Provider.of<FriendProvider>(appContext, listen: false).reloadFriends();

            return true;
          },
          error: (error) {
            Log.e("Reload friends error! code = ${error.code}, message = ${error.message}");

            OtherUtils.showToastMessage('拉取好友信息失败 : ${error.code}!');
            return false;
          }
      );
    }

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