import 'entity_factory.dart';

/// Rest 接口返回对象的基本包装类
class RestResultBaseWrapper<T> {
  int code;
  String message;
  T data;

  RestResultBaseWrapper({this.code, this.message, this.data});

  factory RestResultBaseWrapper.fromJson(json) {
    return RestResultBaseWrapper(
      code: json['code'],
      message: json['message'],
      data: EntityFactory.generateOBJ<T>(json['data']),
    );
  }
}

/// Rest 接口返回对象的 data 为 list 的包装类
class RestResultListWrapper<T> {
  int code;
  String message;
  List<T> data;

  RestResultListWrapper({this.code, this.message, this.data});

  factory RestResultListWrapper.fromJson(json) {
    List<T> mData = List();
    if (json['data'] != null) {
      (json['data'] as List).forEach((v) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      });
    }

    return RestResultListWrapper(
      code: json['code'],
      message: json['message'],
      data: mData,
    );
  }
}

/// http 错误类
class RestErrorEntity {
  int code;
  String message;

  RestErrorEntity({this.code, this.message});
}

/// http 方法类型
enum NWMethod {
  GET,
  POST,
  DELETE,
  PUT
}

const NWMethodValues = {
  NWMethod.GET: "get",
  NWMethod.POST: "post",
  NWMethod.DELETE: "delete",
  NWMethod.PUT: "put"
};