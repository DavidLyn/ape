
/// 用户实体类
class User {
  // 用户 id
  int uid;

  // 用户名
  String name;

  // 昵称
  String nickname;

  // 生日 yyyy-mm-dd
  String birthday;

  // 手机号
  String mobile;

  // email
  String email;

  // 密码摘要:实际用于存放 token
  String password;

  // 盐
  String salt;

  // 头像
  String avatar;

  // 创建时间
  DateTime createAt;

  // 更新时间
  DateTime updateAt;

  // 状态
  int status;

  // 性别 1 - male, 2 - female, 0 - unknown
  int gender;

  // 简介
  String profile;


  User({ this.uid,
    this.name,
    this.nickname,
    this.birthday,
    this.mobile,
    this.email,
    this.password,
    this.salt,
    this.avatar,
    this.createAt,
    this.updateAt,
    this.status,
    this.gender,
    this.profile,
  });

  User.fromJson(json)
      : uid = json["uid"],
        name = json["name"],
        nickname = json["nickname"],
        birthday = json["birthday"],
        mobile = json["mobile"],
        email = json["email"],
        password = json["password"],
        salt = json["salt"],
        avatar = json["avatar"],
        createAt = json["createAt"],
        updateAt = json["updateAt"],
        status = json["status"],
        gender = json['gender'],
        profile = json['profile'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = uid;
    data['name'] = name;
    data['nickname'] = nickname;
    data['birthday'] = birthday;
    data['mobile'] = mobile;
    data['email'] = email;
    data['password'] = password;
    data['salt'] = salt;
    data['avatar'] = avatar;
    data['createAt'] = createAt;
    data['updateAt'] = updateAt;
    data['status'] = status;
    data['gender'] = gender;
    data['profile'] = profile;

    return data;
  }

   /// 取得字符型性别
  String getGenderInChar() {
    switch (this.gender) {
      case 1 :
        return '男';
      case 2 :
        return '女';
      default :
        return '保密';
    }
  }

}