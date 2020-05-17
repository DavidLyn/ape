import 'package:ape/entity/user.dart';

/// 将 json 转换为对象
/// 每增加一个实体类需要修改本类
class EntityFactory {
  static T generateOBJ<T>(json) {
    if (json == null) {
      return null;
    }
    //可以在这里加入任何需要并且可以转换的类型，例如下面
    else if (T.toString() == "User") {
    return User.fromJson(json) as T;
    }
    else {
      return json as T;
    }
  }
}