
/// 用户实体类
class User {
  // 用户名
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

  // 密码摘要
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
  });

}