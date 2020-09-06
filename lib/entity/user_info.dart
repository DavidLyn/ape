
/// 用户基本信息类
class UserInfo {
  // 用户 id
  int uid;

  // 用户名
  String name;

  // 昵称
  String nickname;

  // 生日 yyyy-mm-dd
  String birthday;

  // 头像
  String avatar;

  // 创建时间
  DateTime createAt;

  // 性别 1 - male, 2 - female, 0 - unknown
  int gender;

  // 简介
  String profile;

  // 粉丝数量
  int fanNumber;

  // 关注数量
  int followNumber;

  UserInfo({
    this.uid,
    this.name,
    this.nickname,
    this.birthday,
    this.avatar,
    this.createAt,
    this.gender,
    this.profile,
    this.fanNumber,
    this.followNumber,
  });

  UserInfo.fromMap(map)
      : uid = map['uid'],
        name = map['name'],
        nickname = map['nickname'],
        birthday = map['birthday'],
        avatar = map['avatar'],
        createAt = map['createAt'],
        gender = map['gender'],
        profile = map['profile'],
        fanNumber = map['fanNumber'],
        followNumber = map['followNumber'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = uid;
    data['name'] = name;
    data['nickname'] = nickname;
    data['birthday'] = birthday;
    data['avatar'] = avatar;
    data['createAt'] = createAt;
    data['gender'] = gender;
    data['profile'] = profile;

    data['fanNumber'] = fanNumber;
    data['followNumber'] = followNumber;

    return data;
  }
}