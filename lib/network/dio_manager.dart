import 'dart:async';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

import 'package:ape/network/nw_api.dart';
import 'package:ape/network/rest_result_wrapper.dart';
import 'package:ape/util/log_utils.dart';
import 'package:ape/common/constants.dart';

/// Dio Http 管理类
/// 例子 : 返回 LoginEntity
///DioManager().request<LoginEntity>(
///  NWMethod.POST,
///  NWApi.loginPath,
///  params: <String,dynamic>{"account": "421789838@qq.com", "password": "123456"},
///  success: (data) {
///    print("success data = $data"});
///  }, error: (error) {
///    print("error code = ${error.code}, message = ${error.message}");
///  }
///);

/// 例子 : 返回 List
///DioManager().requestList<LoginEntity>(
///  NWMethod.POST,
///  NWApi.queryListJsonPath,
///  params: <String,dynamic>{"account": "421789838@qq.com", "password": "123456"},
///  success: (data) {
///    print("success data = $data"});
///  }, error: (error) {
///    print("error code = ${error.code}, message = ${error.message}");
///  }
///);
class DioManager {

  static final DioManager _shared = DioManager._internal();

  factory DioManager() => _shared;

  Dio _dio;

  DioManager._internal() {
    if (_dio == null) {

      BaseOptions options = BaseOptions(
        baseUrl: NWApi.baseApi,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: 300000,       // 连接超时设置为 300 秒
        receiveTimeout: 300000,       // 接收超时设置为 300 秒
      );

      _dio = Dio(options);

      // 添加拦截器
      _dio.interceptors.add(_AuthenticationInterceptor());
      _dio.interceptors.add(_LoggingInterceptor());

    }
  }

  // 请求，返回参数为 T
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // data: http body,Map 类型
  // params：URL 请求参数,Map 类型
  // success：请求成功回调
  // error：请求失败回调
  Future request<T>(NWMethod method, String path, {Map data, Map params, Function(T t,String msg) success, Function(RestErrorEntity) error}) async {
    try {
      Response response = await _dio.request(path, data : data, queryParameters: params, options: Options(method: NWMethodValues[method]));
      if (response != null) {
        RestResultBaseWrapper entity = RestResultBaseWrapper<T>.fromJson(response.data);
        if (entity.code == 0) {
          success(entity.data,entity.message);
        } else {
          error(RestErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(RestErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch(e) {
      error(createErrorEntity(e));
    }
  }

  // 请求，返回参数为 List
  // method：请求方法，NWMethod.POST等
  // data: http body,Map 类型
  // path：请求地址,Map 类型
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future requestList<T>(NWMethod method, String path, {Map data, Map params, Function(List<T>) success, Function(RestErrorEntity) error}) async {
    try {
      Response response = await _dio.request(path, data : data, queryParameters: params, options: Options(method: NWMethodValues[method]));
      if (response != null) {
        RestResultListWrapper entity = RestResultListWrapper<T>.fromJson(response.data);

        if (entity.code == 0) {
          success(entity.data);
        } else {
          error(RestErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(RestErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch(e) {
      error(createErrorEntity(e));
    }
  }

  // 上传头像
  Future uploadAvatar( String urlPath,
                       int uid,
                       File image,
                       { Function(String data,String msg) success,
                         Function(RestErrorEntity) error }) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

    FormData formData = FormData.fromMap({
      'uid': uid,
      'file': MultipartFile.fromBytes(
        image.readAsBytesSync(),
        filename: name,
        contentType: MediaType.parse("image/$suffix"),
      ),
    });

    try {
      Response response = await _dio.request(urlPath, data : formData, options: Options(method: 'post'));

      if (response != null) {
        RestResultBaseWrapper entity = RestResultBaseWrapper<String>.fromJson(response.data);
        if (entity.code == 0) {
          success(entity.data,entity.message);
        } else {
          error(RestErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(RestErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch(e) {
      error(createErrorEntity(e));
    }

  }

  /// 下载并保存文件
  Future<bool> downloadFile(fileUrl, savePath) async {
    try {
      await _dio.download(fileUrl, savePath);
      return true;
    } on Exception catch(e) {
      print('Download file error : $e');
      return false;
    }
  }

  // 错误信息
  RestErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:{
        return RestErrorEntity(code: -1, message: "请求取消");
      }
      break;
      case DioErrorType.CONNECT_TIMEOUT:{
        return RestErrorEntity(code: -1, message: "连接超时");
      }
      break;
      case DioErrorType.SEND_TIMEOUT:{
        return RestErrorEntity(code: -1, message: "请求超时");
      }
      break;
      case DioErrorType.RECEIVE_TIMEOUT:{
        return RestErrorEntity(code: -1, message: "响应超时");
      }
      break;
      case DioErrorType.RESPONSE:{
        try {
          int errCode = error.response.statusCode;
          String errMsg = error.response.statusMessage;
          return RestErrorEntity(code: errCode, message: errMsg);
        } on Exception catch(_) {
          return RestErrorEntity(code: -1, message: "未知错误");
        }
      }
      break;
      default: {
        return RestErrorEntity(code: -1, message: error.message);
      }
    }
  }

}

/// 将 token 追加到 header 中的拦截器
class _AuthenticationInterceptor extends Interceptor {

  @override
  onRequest(RequestOptions options) {
    // token 放在 user.password 中
    String token = UserInfo.user.password;
    if (token.isNotEmpty) {
      //options.headers['Authorization'] = 'Bearer $token';
      //options.headers.putIfAbsent('token', () => token);
      options.headers['token'] = token;
    }

    return super.onRequest(options);
  }

}

/// 输出 http 请求响应日志的拦截器
class _LoggingInterceptor extends Interceptor{

  DateTime _startTime;
  DateTime _endTime;

  @override
  onRequest(RequestOptions options) {
    _startTime = DateTime.now();
    Log.d('-------------------- Http Start --------------------');
    if (options.queryParameters.isEmpty) {
      Log.d('RequestUrl: ' + options.baseUrl + options.path);
    } else {
      Log.d('RequestUrl: ' + options.baseUrl + options.path + '?' + Transformer.urlEncodeMap(options.queryParameters));
    }
    Log.d('RequestMethod: ' + options.method);
    Log.d('RequestHeaders:' + options.headers.toString());
    Log.d('RequestContentType: ${options.contentType}');
    Log.d('RequestData: ${options.data.toString()}');
    return super.onRequest(options);
  }

  @override
  onResponse(Response response) {
    _endTime = DateTime.now();
    int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == 200) {
      Log.d('ResponseCode: ${response.statusCode}');
    } else {
      Log.e('ResponseCode: ${response.statusCode}');
    }
    // 输出结果
    //Log.json(response.data.toString());   -- Log.json 会报错
    Log.d(response.data.toString());
    Log.d('-------------------- Http End: $duration 毫秒 --------------------');
    return super.onResponse(response);
  }

  @override
  onError(DioError err) {
    Log.d('----------Error-----------');
    return super.onError(err);
  }
}
